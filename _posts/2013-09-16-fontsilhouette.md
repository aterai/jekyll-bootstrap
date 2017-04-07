---
layout: post
category: swing
folder: FontSilhouette
title: Fontのアウトラインから輪郭を取得する
tags: [Font, PathIterator, Icon, AffineTransform, Shape, JLabel]
author: aterai
pubdate: 2013-09-16T00:01:42+09:00
description: Fontから取得した字形の輪郭を抽出し、縁取りや内部の塗り潰しなどを行います。
image: https://lh5.googleusercontent.com/-kzMG9iEHFz4/UjWgNdHCh1I/AAAAAAAAB2A/0gpKBcNqz44/s800/FontSilhouette.png
comments: true
---
## 概要
`Font`から取得した字形の輪郭を抽出し、縁取りや内部の塗り潰しなどを行います。このサンプルは、[java - 'Fill' Unicode characters in labels - Stack Overflow](https://stackoverflow.com/questions/18686199/fill-unicode-characters-in-labels)に投稿されているコードを参考にしています。

{% download https://lh5.googleusercontent.com/-kzMG9iEHFz4/UjWgNdHCh1I/AAAAAAAAB2A/0gpKBcNqz44/s800/FontSilhouette.png %}

## サンプルコード
<pre class="prettyprint"><code>private static Area getOuterShape(Shape shape) {
  Area area = new Area();
  Path2D path = new Path2D.Double();
  PathIterator pi = shape.getPathIterator(null);
  double[] coords = new double[6];
  while (!pi.isDone()) {
    int pathSegmentType = pi.currentSegment(coords);
    switch (pathSegmentType) {
    case PathIterator.SEG_MOVETO:
      path.moveTo(coords[0], coords[1]);
      break;
    case PathIterator.SEG_LINETO:
      path.lineTo(coords[0], coords[1]);
      break;
    case PathIterator.SEG_QUADTO:
      path.quadTo(coords[0], coords[1], coords[2], coords[3]);
      break;
    case PathIterator.SEG_CUBICTO:
      path.curveTo(coords[0], coords[1], coords[2],
                   coords[3], coords[4], coords[5]);
      break;
    case PathIterator.SEG_CLOSE:
      path.closePath();
      area.add(new Area(path));
      path.reset();
      break;
    default:
      System.err.println("Unexpected value! " + pathSegmentType);
      break;
    }
    pi.next();
  }
  return area;
}
</code></pre>

## 解説
上記のサンプルの下二行は、チェスの駒の字形から輪郭を取得し、それを使って縁取り、内部の塗り潰しを行う`Icon`を`JLabel`に配置して表示しています。

字形(`Shape`)の輪郭は、`Shape#getPathIterator(...)`で`PathIterator`を取得し、~~開始点が一番外側にある~~パスの集合を`Path2D`に変換、`Area`に追加することで作成しています。

## 参考リンク
- [java - 'Fill' Unicode characters in labels - Stack Overflow](https://stackoverflow.com/questions/18686199/fill-unicode-characters-in-labels)

<!-- dummy comment line for breaking list -->

## コメント
- `src.zip`などがダウンロードできるように修正。 -- *aterai* 2013-12-06 (金) 16:37:48
- [漢字の線に囲まれた部分だけを塗りつぶした画像で何の四字熟語か当てるスレ：キニ速](http://blog.livedoor.jp/kinisoku/archives/4204798.html) のような問題を作成するツールを作ってみた。~~アンチエイリアスのせいでフチがボケてしまう。~~ `Area#exclusiveOr(...)`を使用するように修正した。 -- *aterai* 2014-10-16 (金) 19:00:48

<!-- dummy comment line for breaking list -->
![screenshot](https://lh5.googleusercontent.com/-VAupQj3Qbbo/VD-u8nhrHWI/AAAAAAAACQY/xoqXdrCudOE/s800/FontSilhouette2.png)

