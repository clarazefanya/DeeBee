# DeeBee — Design.md v1

## Overview

DeeBee is a portrait-only interactive learning app that teaches basic SQL (focused on DML) through a light visual-novel-inspired experience.

Players act as a new employee at DeeBee, a grocery store located in SQLand, where all store systems are operated using SQL queries directly.

The app combines:

* beginner-friendly learning
* game-like progression
* lightweight storytelling
* interactive SQL exercises

DeeBee is NOT designed as:

* a branching visual novel
* a complex game engine
* a corporate quiz app

Instead, it aims to feel:

* warm
* approachable
* rewarding
* playful
* modern

---

# Branding

## App Name

DeeBee

## Mascot

Bee mascot.

Used for:

* loading states
* success states
* empty states
* error messages
* supportive UI moments

Purpose:

* reduce intimidation for beginner users
* strengthen app identity
* create warmth and friendliness

---

# Visual Direction

## Style Keywords

* Fun
* Beginner Friendly
* Educational
* Modern
* Slightly Game-like
* Clean UI

## Art Style

Semi-flat modern illustration.

Avoid:

* hyper-realistic visuals
* overly childish cartoon style
* cyberpunk/futuristic overload
* heavy anime visual novel styling

## Main Color Palette

Primary:

* Honey Amber Yellow (matching logo)

Secondary:

* White
* Dark Gray
* Soft Black

Accent:

* Soft Green (success)
* Soft Orange/Amber (warning)

Avoid:

* harsh pure black
* aggressive bright red

---

# Responsive Rules

## Orientation

Portrait only.

## Device Support

UI should remain responsive across:

* standard phones
* tall aspect ratio devices
* foldable devices

## Illustration Structure

Scene illustration must use:

* separated background layer
* separated character sprite layer

Reason:

* prevent stretched characters
* improve responsiveness
* allow flexible positioning

---

# Core App Flow

Home
→ Part Select
→ Chapter Select
→ Level Select
→ Gameplay Scene

---

# Home Page

## Purpose

Acts as:

* main hub
* learning entry point
* progression dashboard

## Structure

Scrollable content page with fixed bottom navigation.

### Sections

#### 1. Carousel Banner

Contains:

* Continue / Start Learning
* Feedback / Bug Report
* Leaderboard

#### 2. Overall Progress

Global learning progress bar.

#### 3. Part List

Card-based vertical list.

#### 4. Bottom Navigation

Tabs:

* Home
* Leaderboard
* Profile

---

# Part Select

## Current Parts

* DML
* DDL (Coming Soon)

## Part Card Content

Each card contains:

* part "../design"title
* short description
* progress bar

## Interaction

Tap card to open chapter selection.

---

# Chapter Select

## Layout

Vertical card list.

## Chapter Card Content

Each card contains:

* chapter title
* chapter description
* chapter progress bar

## Goal

Keep UI simple and readable.

---

# Level Select

## Layout

Top:

* Intro/Tutorial button (full width)

Below:

* level grid
* 3 columns per row

## Level Status System

### Completed

* Green
* Check icon

### Current

* Amber/Yellow
* Play icon

### Locked

* Gray
* Lock icon

---

# Gameplay Scene System

Gameplay scenes share one consistent structure while changing the interaction area based on scene type.

## Main Layout

Top Area:

* illustration
* character sprite
* dialog box

Middle Area:

* interaction content
* scrollable when needed

Bottom Area:

* static feedback banner

---

# Dialog System

## Dialog Box Structure

Character Name
Dialog Text

## Position

Dialog box is placed BELOW illustration.

Avoid:

* transparent overlay dialog boxes
* text directly on illustration

---

# Scene Types

## 1. Dialog-only Scene

Purpose:

* storytelling
* transitions
* tutorial explanation
* pacing

Interaction Area:

* Continue button only

Example:
[ Continue ▶ ]

---

## 2. Multiple Choice Scene

User selects one answer option.

Interaction:

* tap-based selection

Purpose:

* beginner learning
* lightweight quizzes

---

## 3. Word Arrangement Scene

User taps words to arrange SQL queries.

Interaction:

* tap-based
* NOT drag-and-drop

Purpose:

* query structure learning

---

## 4. SQL Input Scene

User manually types SQL query.

Components:

* TextField
* Submit button

Purpose:

* active SQL practice

---

# SQL Scene Layout Behavior

## Important Rule

SQL typing scenes use FULL PAGE SCROLL.

Reason:

* keyboard requires more vertical space
* user focus should prioritize query writing

## Non-SQL Scenes

Use split layout:

* illustration/dialog fixed
* interaction area scrollable

---

# Feedback System

## Feedback Style

Use static bottom feedback banner.

Do NOT use:

* popup modal
* fullscreen overlay

## Banner Behavior

* fixed position
* not scrollable
* always accessible

## Success Example

✅ Query berhasil!
[ Next ]

## Failure Example

🟡 Hmm, coba lagi.
[ Retry ]

---

# Progress System

Three progress levels exist:

## 1. Overall Progress

Displayed on Home page.

## 2. Part Progress

Displayed on Part cards.

## 3. Chapter Progress

Displayed on Chapter cards.

---

# UX Philosophy

DeeBee should feel:

* encouraging
* low-pressure
* interactive
* rewarding

The app should avoid:

* overwhelming interfaces
* complicated interactions
* aggressive difficulty presentation

Feedback should feel:

* supportive
* friendly
* lightweight

---

# Features Intentionally Avoided

The following features are intentionally excluded from v1 scope:

* branching story
* multiple endings
* drag-and-drop mechanics
* complex ERD editors
* popup-heavy UI
* zoom interactions
* advanced animation systems
* complicated inventory systems
* massive world exploration

---

# Future Expansion Possibilities

Potential future additions:

* DDL learning content
* leaderboard system
* authentication
* cloud save
* achievement system
* advanced SQL validation
* additional SQL topics
* web version

---

# Design Goal Summary

DeeBee aims to become:
“A beginner-friendly SQL learning experience wrapped inside a light game-like adventure.”
