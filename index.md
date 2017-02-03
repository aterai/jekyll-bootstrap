---
layout: page
title: Front Page
comments: ture
author:
  name: aterai
  email: aterai@outlook.com
  twitter: aterai
---
{% include JB/setup %}
Posted by [aterai](http://ateraimemo.com/:Users/aterai.html) at 2003-09-25

## 概要
このページ以下では、`Java Swing`での`GUI`プログラム作成のコツなどを、 **「小さなサンプル(ソースコード付き)」** を使って紹介しています。

<img alt="screenshots" src="https://lh3.ggpht.com/_9Z4BYR88imo/TQslJy3MxYI/AAAAAAAAAts/xrxOCvbp-0A/s800/screenshots.png" />

- 上の画像をクリックするとスクリーンショットの一覧に移動します。

### Swingとは
`Swing`は、`GUI`(グラフィカル・ユーザ・インタフェース)を作成するための、`Java`標準のコンポーネントセット(ライブラリ、`UI`ツールキット)です。

[About the JFC and Swing (The Java™ Tutorials)](https://docs.oracle.com/javase/tutorial/uiswing/start/about.html)

## 編集方針
- **最も欲しいものはサンプルである** - [steps to phantasien t(2007-07-06)](http://steps.dodgson.org/bn/2007/07/06/#p02)より引用
    - 各ページからダブルクリックなどで実行可能な`JAR`ファイルをダウンロードすることができます。
- `SSCCE` [Short, Self Contained, Correct Example](http://sscce.org/)
- `MCVE` [How to create a Minimal, Complete, and Verifiable example - Help Center - Stack Overflow](https://stackoverflow.com/help/mcve)
    - すべての記事毎にソースコードや画像などのリソース、これらを`Ant`で簡単にコンパイル、実行するための`build.xml`をまとめた`zip`ファイルを添付しています。
    - `Git`リポジトリを取得する場合:  
        <pre><code>git clone https://github.com/aterai/java-swing-tips.git</code></pre>

## 更新履歴

<ul class="posts">
  {% for post in site.posts limit:10 %}
    <li><span>{{ post.date | date: "%Y-%m-%d" }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
