import type { QuizState } from '@/lib/quiz';

type Action = (formData: FormData) => Promise<void>;
const LETTERS = ['A', 'B', 'C', 'D', 'E', 'F'];

// The end-of-lesson check. Multiple choice must be 100% to finish the lesson
// (tries are unlimited, and we only point at which ones to look at again).
// Reflections aren't graded; leadership reads them each week.
export default function Quiz({
  taskId,
  quiz,
  editable,
  action,
}: {
  taskId: string;
  quiz: QuizState;
  editable: boolean;
  action?: Action;
}) {
  const mc = quiz.questions.filter((q) => q.kind === 'mc');
  const shorts = quiz.questions.filter((q) => q.kind === 'short');
  const last = quiz.last;
  const wrong = new Set(last?.wrong ?? []);
  const reflectionMissing = !quiz.passed && last && last.correct === last.total && shorts.some((q) => !quiz.reflections.get(q.id));

  // Finished, or someone reviewing: show the reflections and any notes.
  if (quiz.passed || !editable) {
    return (
      <div className="quiz">
        <div className="quiz-head">
          <span className="t">Lesson check</span>
          {quiz.passed ? (
            <span className="badge">Passed{quiz.tries > 1 ? ` in ${quiz.tries} tries` : ''}</span>
          ) : (
            <span className="badge grey">{quiz.tries ? `Not passed yet · ${quiz.tries} ${quiz.tries === 1 ? 'try' : 'tries'}` : 'Not started'}</span>
          )}
        </div>
        {shorts.map((q) => {
          const r = quiz.reflections.get(q.id);
          return (
            <div key={q.id} className="quiz-q">
              <span className="sub" style={{ fontWeight: 600 }}>{q.prompt}</span>
              {r ? <p className="quiz-answer">{r.answer}</p> : <p className="sub">No reflection yet.</p>}
              {r?.comment ? (
                <p className="quiz-note"><strong>Leadership note:</strong> {r.comment}</p>
              ) : r ? (
                <span className="sub">{r.reviewed_at ? 'Reviewed by leadership.' : 'Waiting on leadership review.'}</span>
              ) : null}
            </div>
          );
        })}
      </div>
    );
  }

  return (
    <details className="quiz" open={!!last}>
      <summary className="btn blue" style={{ listStyle: 'none', display: 'inline-flex' }}>
        {last ? 'Keep going on the lesson check' : 'Take the lesson check'}
      </summary>
      <form action={action} className="stack" style={{ marginTop: 14, gap: 18 }}>
        <input type="hidden" name="taskId" value={taskId} />
        <p className="sub">
          Get every multiple-choice question right to finish this lesson. Take it as many times as you need. The reflection
          isn&apos;t graded. Leadership reads it each week.
        </p>
        {last && last.correct < last.total ? (
          <p className="quiz-flag" role="status">
            {last.correct} of {last.total} right. Reread the lesson and look again at the questions marked below.
          </p>
        ) : null}
        {reflectionMissing ? (
          <p className="quiz-flag" role="status">Every answer is right. Write your reflection to finish.</p>
        ) : null}

        {mc.map((q, i) => {
          const prev = last?.answers?.[q.id];
          const isWrong = wrong.has(q.id);
          return (
            <fieldset key={q.id} className={`quiz-q${isWrong ? ' wrong' : ''}`}>
              <legend>
                <span className="quiz-n">{i + 1}.</span> {q.prompt}
                {isWrong ? <span className="quiz-tag">Look again</span> : null}
              </legend>
              {q.choices.map((c, ci) => (
                <label key={ci} className="quiz-choice">
                  <input type="radio" name={`q:${q.id}`} value={ci} required defaultChecked={!isWrong && prev !== undefined && String(prev) === String(ci)} />
                  <span><b>{LETTERS[ci]}</b> {c}</span>
                </label>
              ))}
            </fieldset>
          );
        })}

        {shorts.map((q) => {
          const r = quiz.reflections.get(q.id);
          const prev = r?.answer ?? (typeof last?.answers?.[q.id] === 'string' ? String(last?.answers?.[q.id]) : '');
          return (
            <div key={q.id} className="quiz-q">
              <label htmlFor={`r-${q.id}`} style={{ fontWeight: 600 }}>
                Reflection: {q.prompt}
              </label>
              <textarea id={`r-${q.id}`} className="textarea" name={`q:${q.id}`} required defaultValue={prev} />
              {r?.comment ? <p className="quiz-note"><strong>Leadership note:</strong> {r.comment}</p> : null}
            </div>
          );
        })}

        <div>
          <button className="btn primary" type="submit">Check my answers</button>
        </div>
      </form>
    </details>
  );
}
