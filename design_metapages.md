# DeeBee — Meta Pages Design.md v1

Covers:

* Leaderboard Page
* Profile Page

Both pages belong to DeeBee's **Meta / Social / Account Layer**.

---

# Shared Meta Page Rules

## Navigation Flow

Bottom Navigation Bar is always visible.

Navigation structure:

```plaintext
Home | Leaderboard | Profile
```

Flow:

```plaintext
Navbar → Leaderboard

Navbar → Profile
```

Direct navigation only.

No intermediate page.

---

# Shared Header Structure

Use DeeBee global header.

Structure:

```plaintext
[ DeeBee ]      [ ⚙️ ]      [ XP Capsule + Avatar ]
```

Purpose:

* maintain consistency
* keep branding visible
* keep user identity accessible

---

# Shared Visual Direction

Meta pages may use:

Honey Amber Yellow background styling.

Unlike gameplay pages, these pages can feel:

* more celebratory
* more branded
* slightly more social/game-like

---

# Shared Background System

Avoid:

* full white pages
* solid full-screen yellow pages

Recommended pattern:

Yellow hero background

White / #FFF8F3 content containers.

Example hierarchy:

```plaintext
HEADER

(Yellow Hero Area)

(Content)

Bottom Navbar
```

---

# LEADERBOARD PAGE

## Purpose

Leaderboard provides lightweight competition and progression motivation.

Goal:

* reinforce XP system
* encourage progression
* support game-like feeling

Competition should feel:

lightweight and friendly.

---

## Page Structure

```plaintext
Global Header

↓

Yellow Hero Area

↓

Scrollable Ranking Content

↓

Bottom Navigation Bar
```

---

## Hero Area

Background:

Honey Amber Yellow.

Contents:

Centered title.

Primary title:

Leaderboard

Optional subtitle:

Top SQL Employees

Example:

```plaintext
Leaderboard

Top SQL Employees
```

---

## Ranking Scope

Single leaderboard only.

Type:

Overall XP Leaderboard.

Ranking determined by:

Total accumulated XP.

Excluded from v1:

* streak leaderboard
* weekly leaderboard
* chapter leaderboard
* friends leaderboard

---

## Ranking Display Style

Use:

mobile-friendly ranking list.

Avoid:

spreadsheet-like table UI.

Preferred layout:

```plaintext
🥇 Clara           1520 XP
🥈 BeeWorker        1450 XP
🥉 SQLMaster        1300 XP

4  DataBee          1100 XP
5  HoneyBee          980 XP
```

---

## Ranking Row Structure

Each row contains:

* rank indicator
* username
* total XP

Recommended layout:

Left:

rank + username

Right:

XP value.

Example:

```plaintext
🥇 Clara                    1520 XP
```

---

## Top 3 Styling

Recommended.

Top three users may use:

🥇 Gold

🥈 Silver

🥉 Bronze

Purpose:

* clearer ranking hierarchy
* stronger achievement feeling

---

## Current User Highlight

Recommended feature.

If logged-in user appears in ranking:

highlight their row.

Possible styling:

* yellow border
* different surface color
* stronger emphasis

---

## Scroll Behavior

Ranking content scrolls.

Header remains fixed.

Bottom navigation remains fixed.

---

## Empty State (Optional)

If leaderboard contains no data:

```plaintext
🐝

Belum ada ranking tersedia.

Mulai kerjakan level untuk mendapatkan XP!
```

---

## Bottom Navigation

Always visible.

Structure:

```plaintext
Home | Leaderboard | Profile
```

Leaderboard icon/tab is active.

---

# PROFILE PAGE

## Purpose

Profile page functions as:

* identity page
* account overview
* personal progress dashboard

---

## Page Structure

```plaintext
Global Header

↓

Yellow Hero Area

↓

Employee Card

↓

Stats Row

↓

Action Menu

↓

Danger Zone

↓

Logout

↓

Bottom Navigation Bar
```

---

## Page Title

Large "Profile" title is optional.

Recommended approach:

Skip dedicated title.

Allow Employee Card to become the visual focus.

---

## Employee Card

Primary profile component.

Visual direction:

Employee ID Card / Name Card inspired layout.

Purpose:

reinforce DeeBee lore.

---

## Employee Card Layout

Recommended structure:

```plaintext
╭──────────────────────────────╮
│ [ AVATAR ]   Nama Karyawan   │
│ [        ]   Clara           │
│ [        ]                   │
│              Email           │
│              clara@mail.com  │
│                              │
│              Bergabung sejak │
│              12 Mei 2026     │
│                              │
│              1540 XP         │
╰──────────────────────────────╯
```

---

## Avatar

Avatar appears on the left.

Shape:

vertical rectangle / portrait badge style.

Because DeeBee uses:

preset avatar selection

instead of uploaded profile photos.

---

## Employee Card Data

Display:

* Avatar
* Nama Karyawan
* Email
* Bergabung sejak
* Total XP

Field naming:

Use:

Nama Karyawan

instead of:

Username

Date format:

Bahasa Indonesia.

Example:

```plaintext
Bergabung sejak

12 Mei 2026
```

---

## XP Placement

XP is included inside Employee Card.

Do NOT separate XP into external stats row.

Reason:

XP is core identity information.

---

## Stats Row

Horizontal information section.

Recommended metrics:

* Progress
* Level Selesai
* Chapter Selesai

Example:

```plaintext
[ Progress ]
72%

[ Level Selesai ]
42

[ Chapter Selesai ]
4
```

Purpose:

provide quick learning overview.

---

## Action Menu

Normal action section.

Recommended items:

```plaintext
⚙️ Settings

💬 Feedback & Bug Report

🐝 About DeeBee
```

Notes:

Use:

Feedback & Bug Report

instead of:

kritik dan saran

---

## Danger Zone

Separate destructive actions from normal menu.

Recommended structure:

```plaintext
Reset Progress

Delete Account
```

Styling:

Red emphasis.

Purpose:

clear mental separation.

---

## Logout Placement

Logout remains separate from Danger Zone.

Do NOT combine with destructive actions.

Recommended layout:

```plaintext
Normal Actions

────────────

Danger Zone

Reset Progress
Delete Account

────────────

Logout
```

Logout styling:

neutral button or outlined button.

Not red.

---

## Scroll Behavior

Body content scrolls.

Header remains fixed.

Bottom navigation remains fixed.

---

## Bottom Navigation

Always visible.

Structure:

```plaintext
Home | Leaderboard | Profile
```

Profile icon/tab is active.

---

# UX Principles

Meta pages should feel:

* branded
* warm
* rewarding
* beginner-friendly

They should reinforce DeeBee's identity as:

“A beginner-friendly SQL learning app with light game-inspired progression.”
