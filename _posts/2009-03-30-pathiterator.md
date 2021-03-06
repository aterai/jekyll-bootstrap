---
layout: post
category: swing
folder: PathIterator
title: PathIteratorからSVGを生成
tags: [Icon, Shape, PathIterator]
author: aterai
pubdate: 2009-03-30T14:13:46+09:00
description: ShapeからPathIteratorを取得し、このPathをSVGに変換します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTQ-2m7pMI/AAAAAAAAAgc/B55RHlb8ajM/s800/PathIterator.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2013/02/get-svg-from-pathiterator.html
    lang: en
comments: true
---
## 概要
`Shape`から`PathIterator`を取得し、この`Path`を`SVG`に変換します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTQ-2m7pMI/AAAAAAAAAgc/B55RHlb8ajM/s800/PathIterator.png %}

## サンプルコード
<pre class="prettyprint"><code>private StringBuilder makeStarburstSvg(
      PathIterator pi, int sz, String style, String desc) {
  StringBuilder sb = new StringBuilder();
  sb.append("&lt;?xml version=\"1.0\" encoding=\"UTF-8\"?&gt;\n");
  // ...
  sb.append(String.format(
      "&lt;svg width=\"%d\" height=\"%d\" xmlns=\"%s\"&gt;%n", sz, sz, w3));
  sb.append(String.format("  &lt;desc&gt;%s&lt;/desc&gt;%n", desc));
  sb.append("  &lt;path d=\"");
  double[] c = new double[6];
  while (!pi.isDone()) {
    switch (pi.currentSegment(c)) {
      case PathIterator.SEG_MOVETO:
        sb.append(String.format("M%.2f,%.2f ", c[0], c[1])); break;
      case PathIterator.SEG_LINETO:
        sb.append(String.format("L%.2f,%.2f ", c[0], c[1])); break;
      case PathIterator.SEG_QUADTO:
        sb.append(String.format("Q%.2f,%.2f,%.2f,%.2f ",
                                c[0], c[1], c[2], c[3]));
        break;
      case PathIterator.SEG_CUBICTO:
        sb.append(String.format("C%.2f,%.2f,%.2f,%.2f,%.2f,%.2f ",
                                c[0], c[1], c[2], c[3], c[4], c[5]));
        break;
      case PathIterator.SEG_CLOSE:
        sb.append("Z");
        break;
    }
    pi.next();
  }
  sb.append(String.format("\" style=\"%s\" /&gt;%n&lt;/svg&gt;%n", style));
  return sb;
}
</code></pre>

## 解説
上記のサンプルでは、`Shape`から`PathIterator`を取得しそのパスを辿って`SVG`ファイルを生成しています。

## 参考リンク
- [PathIterator (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/geom/PathIterator.html)
- [SVG 1.1 仕様 （第２版） 日本語訳](http://www.hcn.zaq.ne.jp/___/SVG11-2nd/index.html)
    - [パス – SVG 1.1 （第２版）](http://www.hcn.zaq.ne.jp/___/SVG11-2nd/paths.html)
- [SVG Path](http://www.w3schools.com/svg/svg_path.asp)
- [Inkscape 自由に描く。](http://www.inkscape.org/)

<!-- dummy comment line for breaking list -->

## コメント
- サンプルコードにはコードすべて表示（記入）した方がいいと思います。 -- *名無し* 2012-03-27 (火) 21:48:06
- 追記：そうじゃなくてはわかりにくいので。例えばJavaDriveさんのように -- *名無し* 2012-03-27 (火) 21:48:48
    - ご指摘ありがとうございます。現状、大きめのサンプルではコードを丸ごと貼り付けるとページが長くなる、小さいサンプルでもあまり意味のないコードが毎回でてくる…、などの理由でコードの一部(`Tips for the Code Snippets`)だけ表示するようにしています。コード全部を見たい場合は、`src.zip`を展開して好みのエディタで開くか、リポジトリ(`svn repository`)をたどってくださいという姿勢なんですが、自分でもたまにリポジトリをクリックしていくのが面倒なことがあるので、一気に`*.java`にジャンプできるようなリンクでも追加できないか検討してみます。 -- *aterai* 2012-03-28 (水) 15:58:59
- `<pre>`の右上の`view plain`リンクをクリックすると`svn`リポジトリのソースコードを表示するようにしてみました。`MainPanel.java`固定で、`HogeHogeUI.java`などにはリンクしていませんが、面倒なので多分このままです。 -- *aterai* 2012-06-14 (木) 21:25:49
- 現状のままで良いかと。主要な部分だけ見えれば参考になりますしおすし --  2013-02-08 (金) 09:55:45
    - おすし。もうすこし工夫すれば、多少見やすく(使いやすく)なりそうな気はするのですが、上にも書いたようにしばらくはこのままです。 -- *aterai* 2013-02-09 (土) 00:00:18

<!-- dummy comment line for breaking list -->
