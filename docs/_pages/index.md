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
      url: 'https://github.com/mmistakes/minimal-mistakes/'
  caption: 'Photo credit: [**Unsplash**](https://unsplash.com)'
excerpt: '🔬 Shell Specifications'
intro:
  - excerpt: '`specs` is a lovely testing framework for BASH and shell scripts.'
feature_row:
  - image_path: assets/images/bdd.png
    title: 'BDD Style'
    excerpt: 'Comfortable `it.does_something()` syntax<br>for BDD developers'
  - image_path: /assets/images/xunit.png
    alt: 'placeholder image 2'
    title: 'xUnit Style'
    excerpt: 'Comfortable `testSomething()` syntax<br>for xUnit developers'
    url: '#test-link'
    btn_label: 'Read More'
    btn_class: 'btn--primary'
  - image_path: /assets/images/console.png
    title: 'Command-Line'
    excerpt: 'Powerful and familiar command-line interface<br>for all developers'
feature_row2:
  - image_path: /assets/images/unsplash-gallery-image-2-th.jpg
    alt: 'placeholder image 2'
    title: 'Placeholder Image Left Aligned'
    excerpt: 'This is some sample content that goes here with **Markdown** formatting. Left aligned with `type="left"`'
    url: '#test-link'
    btn_label: 'Read More'
    btn_class: 'btn--primary'
feature_row3:
  - image_path: /assets/images/unsplash-gallery-image-2-th.jpg
    alt: 'placeholder image 2'
    title: 'Placeholder Image Right Aligned'
    excerpt: This is some sample content
      <pre class="highlight">
      local foo
      echo "$foo"
      </pre>
      Did that work?
    url: '#test-link'
    btn_label: 'Read More'
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

<!--
{% include feature_row id="feature_row2" type="left" %}

{% include feature_row id="feature_row3" type="right" %}

{% include feature_row id="feature_row4" type="center" %}
-->
