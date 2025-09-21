---
title: "Hello World"
date: 2024-01-20
draft: false
tags: ["introduction", "meta"]
categories: ["general"]
summary: "Welcome to my new website built with Hugo and Nix!"
---

# Hello World!

Welcome to my new website! This site is built with [Hugo](https://gohugo.io/) and managed with [Nix flakes](https://nixos.wiki/wiki/Flakes) for reproducible builds.

## Why Hugo and Nix?

I chose this stack because:

1. **Hugo** is blazing fast and produces static sites
2. **Nix** ensures my build environment is reproducible
3. Together they make deployment simple and reliable

## What's Coming

I'll be writing about:

- Software development
- Nix and NixOS
- Open source projects
- Technical tutorials

## Code Example

Here's how easy it is to build this site with Nix:

```bash
# Build the website
nix build

# Start development server
nix develop -c hugo server -D

# Deploy to production
nix run .#deploy
```

Stay tuned for more content!
