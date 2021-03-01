---
title: 'Specs'
layout: splash
permalink: /
date: 2016-03-23T11:48:41-04:00
header:
  overlay_color: '#000'
  overlay_filter: '0.5'
  overlay_image: /assets/images/parker.jpg
  actions:
    - label: 'Download'
      url: 'https://github.com/shells-sh/specs.sh'
  caption: 'Photo credit: [**Rebecca Taylor**](https://github.com/beccasaurus)'
excerpt: '🔬 Shell Specifications'
intro:
  - excerpt: '`specs` is a lovely testing framework for BASH and shell scripts.'
feature_row:
  - image_path: assets/images/bdd.png
    title: 'BDD Style'
    excerpt: 'Comfortable `it.does_something()` syntax<br>for BDD developers'
  - image_path: /assets/images/xunit.png
    title: 'xUnit Style'
    excerpt: 'Comfortable `testSomething()` syntax<br>for xUnit developers'
  - image_path: /assets/images/console.png
    title: 'Command-Line'
    excerpt: 'Powerful and familiar command-line interface<br>for all developers'
feature_row2:
  - image_path: /assets/images/userDocs.png
    title: 'Well Documented'
    excerpt: |
      Head on over to the User Guide for a quick "Hello, world!" tutorial and all the information you\'ll need to get up-and-running fast with `specs`
      - Supports TAP output
      - Supports JUnit XML output
      - Built-in Assertion/Expectation library
      - Built-in Mocking/Stubbing library
    url: '/docs'
    btn_label: 'Get Started'
    btn_class: 'btn--primary'
feature_row3:
  - image_path: /assets/images/developerDocs.png
    title: 'Fully Customizable'
    excerpt: |
      Specs is fully customizable and extensible:
      - Custom Spec Assertions
      - Custom Output Formatters
      - Custom DSL Styles
    url: '/developer'
    btn_label: 'Developer Guide'
    btn_class: 'btn--primary'
feature_row4:
  - image_path: /assets/images/unsplash-gallery-image-2-th.jpg
    alt: 'placeholder image 2'
    title: 'Placeholder Image Center Aligned'
    excerpt: 'This is some sample content that goes here with **Markdown** formatting. Centered with `type="center"`'
    url: '#test-link'
    btn_label: 'Read More'
    btn_class: 'btn--primary'
---

{% include feature_row id="intro" type="center" %}

{% include feature_row %}

{% include feature_row id="feature_row2" type="left" %}

{% include feature_row id="feature_row3" type="right" %}

<!--
{% include feature_row id="feature_row4" type="center" %}
-->
