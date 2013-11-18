---
layout: post
title: Fontのアウトラインから輪郭を取得する
category: swing
folder: FontSilhouette
tags: [Font, PathIterator, Icon, AffineTransform, Shape, JLabel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-09-16

## Fontのアウトラインから輪郭を取得する
`Font`から取得した字形の輪郭を抽出し、縁取りや内部の塗り潰しなどを行います。このサンプルは、[java - 'Fill' Unicode characters in labels - Stack Overflow](http://stackoverflow.com/questions/18686199/fill-unicode-characters-in-labels)に投稿されているコードを参考にしています。

{% download %}

![screenshot](https://lh5.googleusercontent.com/-kzMG9iEHFz4/UjWgNdHCh1I/AAAAAAAAB2A/0gpKBcNqz44/s800/FontSilhouette.png)

### サンプルコード
<pre class="prettyprint"><code>public static Area getOuterShape(Shape shape) {
  Area area = new Area();
  double[] coords = new double[6];
  PathIterator pi = shape.getPathIterator(null);
  Path2D.Double path = null;
  while(!pi.isDone()) {
    int pathSegmentType = pi.currentSegment(coords);
    if(pathSegmentType == PathIterator.SEG_MOVETO) {
      if(area.isEmpty() || !area.contains(coords[0], coords[1])) {
        path = new Path2D.Double();
        path.moveTo(coords[0], coords[1]);
      }
    }else if(path==null) {
      pi.next();
      continue;
    }else if(pathSegmentType == PathIterator.SEG_LINETO) {
      path.lineTo(coords[0], coords[1]);
    }else if(pathSegmentType == PathIterator.SEG_QUADTO) {
      path.quadTo(coords[0], coords[1], coords[2], coords[3]);
    }else if(pathSegmentType == PathIterator.SEG_CUBICTO) {
      path.curveTo(coords[0], coords[1], coords[2],
                   coords[3], coords[4], coords[5]);
    }else if(pathSegmentType == PathIterator.SEG_CLOSE) {
      path.closePath();
      area.add(new Area(path));
      path = null;
    }else{
      System.err.println("Unexpected value! " + pathSegmentType);
    }
    pi.next();
  }
  return area;
}
</code></pre>

### 解説
上記のサンプルの下二行は、チェスの駒の字形から輪郭を取得し、それを使って縁取り、内部の塗り潰しを行う`Icon`を`JLabel`に配置して表示しています。

字形(`Shape`)の輪郭は、`Shape#getPathIterator(...)`で字形からパスを取得し、開始点が一番外側にあるパスの集合を`Path2D`に変換、`Area`に追加することで作成しています。

### 参考リンク
- [java - 'Fill' Unicode characters in labels - Stack Overflow](http://stackoverflow.com/questions/18686199/fill-unicode-characters-in-labels)

<!-- dummy comment line for breaking list -->

### コメント
