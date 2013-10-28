---
layout: page
title: Front Page
#tagline: Supporting tagline
comments : ture
author :
  name : aterai
  email : at.terai@gmail.com
  twitter : aterai
---
{% include JB/setup %}
Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-09-25
## 概要
このページ以下では、`Java Swing`での`GUI`プログラム作成のコツなどを、 **「小さなサンプル(ソースコード付き)」** を使って紹介しています。

<a href="https://picasaweb.google.com/at.terai/JavaSwingTips02"><img src="http://lh3.ggpht.com/_9Z4BYR88imo/TQslJy3MxYI/AAAAAAAAAts/xrxOCvbp-0A/s800/screenshots.png" /></a>

- 上の画像をクリックするとスクリーンショットの一覧に移動します。

### Swingとは
`Swing`は、`GUI`(グラフィカル・ユーザ・インタフェース)を作成するための、`Java`標準のコンポーネントセット(ライブラリ、`UI`ツールキット)です。

[About the JFC and Swing (The Java™ Tutorials)](http://docs.oracle.com/javase/tutorial/uiswing/start/about.html)

## 編集方針
- **最も欲しいものはサンプルである** - [steps to phantasien t(2007-07-06)](http://dodgson.org/omo/t/?date=20070706#p02)より引用
    - ボタンをクリックするだけで、サンプルプログラムを起動することが出来ます。
        - これらのサンプルは、`Java Web Start`のサンドボックス内で実行され、ローカル`PC`のリソースにはアクセスしません。アクセスする必要のあるサンプルは、ソースファイルなどをダウンロードして確認してから実行してください。
    - すべてのソースコードを[Subversionのリポジトリ](http://code.google.com/p/java-swing-tips/source/checkout)から、以下のようにして取得することができます。

			svn checkout http://java-swing-tips.googlecode.com/svn/trunk/ java-swing-tips-read-only

    - 一時ファイルを保持する設定の場合、[Java キャッシュビューア](http://terai.xrea.jp/data/jws/player.jnlp)から、一度試したサンプルを再度実行したり、全部まとめてアンインストール(`javaws -uninstall`)することができます。
        - 参考: [某開発者の独り言: JWSのJavaアプリケーションキャッシュビューア](http://aqubiblog.blogspot.com/2008/02/jwsjava.html)
        - `Java`コントロールパネル(`javaws -viewer`) から一時ファイル表示でもキャッシュ一覧が起動します。

- **SSCCE** - [Short, Self Contained, Correct Example](http://sscce.org/)
    - すべての記事にソースコードや画像などのリソース、これらを`Ant`で簡単にコンパイル、実行するための`build.xml`をまとめた`zip`ファイルを添付しています。
    - [(Java Swing 引用メモ) Swingのサンプルに関するメモ](http://d.hatena.ne.jp/aterai/20071016/1192516545)

## 更新履歴

<ul class="posts">
  {% for post in site.posts limit:10 %}
    <li><span>{{ post.date | date: "%Y-%m-%d" }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

