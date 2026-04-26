# prove-it

A Claude Code skill that challenges tests to actually catch bugs. If a test would pass even when the code is wrong, it's theater -- not testing.

## Install

**Plugin marketplace:**

```bash
claude plugin add josharsh/prove-it
```

**Manual:**

```bash
git clone https://github.com/josharsh/prove-it.git
cd prove-it
bash install.sh
```

Or copy directly:

```bash
mkdir -p ~/.claude/skills/prove-it
cp skills/prove-it/SKILL.md ~/.claude/skills/prove-it/SKILL.md
```

## Demo

```
You: /prove-it check

Prove It enabled. I'll challenge tests to make sure they actually catch bugs.

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

## Why This Exists

AI-generated tests achieve 95% coverage but catch nothing. Tests that construct data and assert on that same data. Tests where `toBeDefined()` is the only assertion. Tests that duplicate the implementation to compute expected values.

43% of AI-generated code changes need debugging in production. Coverage numbers feel good. Bug counts don't change. The problem isn't that we lack tests -- it's that the tests don't prove anything.

## Commands

- **`/prove-it`** -- Activate the skill. Automatically reviews tests as you write them.
- **`/prove-it check`** -- Immediately scan and review the most recent test file.

## Uninstalling

**Plugin marketplace:**

```bash
claude plugin remove prove-it
```

**Manual:**

```bash
rm -rf ~/.claude/skills/prove-it
```

## License

MIT
