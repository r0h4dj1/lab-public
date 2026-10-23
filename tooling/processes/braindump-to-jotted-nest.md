# Braindump to Jotted Nest

A lightweight process for turning a messy, raw idea or brain dump into a nested
bulleted list (a "jotted nest"). It organizes your thoughts without forcing you
into rigid documentation. It leaves clean hooks to return to and expand later.

## When to use this

Use this when:

- You have a sudden product idea or a raw text dump.
- You want to capture the core features and challenges of an idea quickly.

Do not use this for detailing full product specs or step-by-step implementation
plans.

## The framework

Keep the output entirely bullet-based. Use short fragments and natural nested
lists instead of forcing rigid header prefixes (like "The Pitch" or "The Bits").

Use the following concepts to guide your thinking, but write the final nest in a
clean, natural flow:

- **Core Hook:** A first-level bullet stating the platform/type, working title,
  or key concept and its main hook.
- **Key Features/Mechanics:** Sub-bullets describing specific ideas, features,
  or details.
- **Open Questions/Blockers:** Questions or immediate challenges that need to be
  resolved.
- **The Vibe:** Subtle notes on aesthetics, tone, or comparisons.

Do NOT use literal headers/prefixes (like "The Pitch:", "The Bits:", "The
Blockers:") in the final output. Let the structure of the nested bullets convey
the meaning naturally.

## Step-by-step process

### 1. Write the raw dump

Write down all your initial thoughts without filtering. Capture features,
worries, UI ideas, and platform details.

### 2. Identify the core hook

Summarize the concept and its main value or target audience in the main bullet.

### 3. Extract the features/bits

Select the most important features, details, or characteristics. Nest them
cleanly under the core hook.

### 4. Note blockers and open questions

Write down any immediate hurdles or questions as natural sub-bullets.

### 5. Save the nest

Format your idea cleanly and append it to your chosen target list or file.

---

## Template

```md
- [Platform/Type]: [Working Title or Core Idea] - [Brief hook/description]
  - [Key feature or mechanic]
    - [Additional detail or sub-feature]
  - [Key feature or mechanic]
  - [Immediate challenge, question, or vibe note]
```

---

## Example conversion

### Raw braindump
>
> had an idea for a website where you can just put in the ingredients you have
> left in your fridge and it gives you a recipe but specifically it needs to be
> passive aggressive if you only have weird stuff like ketchup and a single egg.
> maybe call it 'what's wrong with your fridge'. needs to be super fast, no long
> stories before the recipe. maybe uses AI to generate the snark.

### Jotted nest output

```md
- Web App: "What's Wrong With Your Fridge" - Snarky reverse recipe generator
  - Input a list of random ingredients to get a usable recipe
  - The AI outputs a recipe alongside heavy passive-aggressive judgment for your life choices
  - Super fast UI with zero fluff or typical "recipe blog" backstories
  - Open questions:
    - How to handle recipe generation? (Custom prompt for AI snark based on ingredient combo)
  - Vibe: Minimalist design, insulting but actually useful
```
