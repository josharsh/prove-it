# prove-it

A Claude Code skill that challenges tests to actually catch bugs.

## Install

**Plugin marketplace:**
```
/plugin marketplace add https://github.com/josharsh/prove-it
```

**Manual:** Copy `skills/prove-it/SKILL.md` to `~/.claude/skills/prove-it/`.

## Why I Built This

I asked Claude to write tests for a cart module. It gave me 12 tests, all green, 95% coverage. Looked great.

Then I read them. One test imported `calculateTotal` but never called it -- it computed the total inline with `reduce()` and asserted on that. Another test's only assertion was `toBeDefined()`. A third one replicated the discount logic from the implementation to compute the expected value, so if the code was wrong, the test would be wrong in the exact same way.

Coverage was high. Confidence was zero. These tests would pass if I replaced the entire module with `return 42`.

`/prove-it` makes Claude skeptic about its own tests. Every test gets a verdict: **PASSES**, **WEAK**, or **THEATER**.

## Demo

```
You: /prove-it check

## Test Review: cart.test.ts

### "calculates total correctly"
- **Verdict:** THEATER
- **Issue:** Test computes its own total with reduce() but never calls calculateTotal()
- **Fix:** Replace manual reduce with `expect(calculateTotal(items)).toBe(35)`

### "fetches user by id"
- **Verdict:** WEAK
- **Issue:** toBeDefined() passes even if getUser returns { name: "WRONG" }
- **Fix:** Assert on specific fields: `expect(user.name).toBe('Alice')`

### "validates email format"
- **Verdict:** PASSES
- **Issue:** None — checks both valid and invalid inputs with specific values

### Summary
- 3 tests reviewed
- 1 solid, 1 weak, 1 theater
```

## The Six Checks

1. **Does it call the actual code?** Tests that construct and assert on their own data are theater.
2. **Would it fail on a wrong value?** `toBeDefined()` and `not.toThrow()` are almost always too loose.
3. **Is the expected value hardcoded?** If the test recomputes the answer with the same logic, both can be wrong together.
4. **Are edge cases covered?** Empty input, null, boundaries, error paths -- at least 2 per function.
5. **Does the mock match reality?** Mocks that only return happy-path data hide real failures.
6. **Is the test name honest?** A test named "validates email" should actually check validation results.

## How It Works

Two modes:

- **Automatic** -- after writing any test, Claude reviews it against the six checks before showing it to you. Bad tests get fixed before you see them.
- **On demand** -- say "prove it", "review my tests", or run `/prove-it check` to review existing tests.

## Commands

| Command | What it does |
|---|---|
| `/prove-it` | Activate. Reviews tests automatically as you write them |
| `/prove-it check` | Review the most recent test file right now |

## Testing

Tested with [skillmother](https://github.com/josharsh/skillmother):

```bash
skillmother test skills/prove-it/
```

## Uninstalling

```bash
rm -rf ~/.claude/skills/prove-it
```

## License

MIT
