---
layout: post
category: swing
folder: BoundedRangeModel
title: JLabelとIconで作成した検索位置表示バーをマウスで操作する
tags: [JLabel, Icon, BoundedRangeModel, JScrollBar, JTable]
author: aterai
pubdate: 2014-02-17T02:41:10+09:00
description: JScrollBarからBoundedRangeModelを取得し、JLabelとIconで表示した検索位置表示バーをマウスで操作可能にします。
image: https://lh4.googleusercontent.com/-EN1vcmWX7Gs/UwDyGP5n91I/AAAAAAAACAE/tb9w7pHxtk8/s800/BoundedRangeModel.png
comments: true
---
## 概要
`JScrollBar`から`BoundedRangeModel`を取得し、`JLabel`と`Icon`で表示した検索位置表示バーをマウスで操作可能にします。

{% download https://lh4.googleusercontent.com/-EN1vcmWX7Gs/UwDyGP5n91I/AAAAAAAACAE/tb9w7pHxtk8/s800/BoundedRangeModel.png %}

## サンプルコード
<pre class="prettyprint"><code>class HighlightBarHandler extends MouseAdapter {
  private void processMouseEvent(MouseEvent e) {
    Point pt = e.getPoint();
    Component c = e.getComponent();
    BoundedRangeModel m = scrollbar.getModel();
    int h = m.getMaximum() - m.getMinimum();
    int iv = (int) (.5 - m.getExtent() * .5 + pt.y * h / (double) c.getHeight());
    m.setValue(iv);
  }
  @Override public void mousePressed(MouseEvent e) {
    processMouseEvent(e);
  }
  @Override public void mouseDragged(MouseEvent e) {
    processMouseEvent(e);
  }
}
</code></pre>

## 解説
- `Icon`に検索結果をハイライト表示し、`JLabel`に設定
    - この`JLabel`は`JScrollPane`の子コンポーネントではないので、縦`JScrollBar`の`BoundedRangeModel`に`ChangeListener`を追加し、更新ごとに`JLabel#repaint()`もあわせて実行する必要がある
- `JLabel`上の表示範囲をマウスで操作可能にするため、`MouseListener`などを追加
    - 位置は`JScrollBar`から`BoundedRangeModel`を取得して計算する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [BoundedRangeModel (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/BoundedRangeModel.html)
- [JScrollBarに検索結果をハイライト表示](http://ateraimemo.com/Swing/ScrollBarSearchHighlighter.html)

<!-- dummy comment line for breaking list -->

## コメント
- ハイライトのサンプルとして`JTable`を使用しているが、実際に`JTable`の行数が多くなるなら[JTableの検索結果をRowFilterとHighlighterで強調表示する](http://ateraimemo.com/Swing/TableHighlightRegexFilter.html)のようにフィルタを使用するほうが見やすそう。 -- *aterai* 2014-02-17 (月) 02:41:10

<!-- dummy comment line for breaking list -->
