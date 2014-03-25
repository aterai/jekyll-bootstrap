---
layout: post
title: JLabelとIconで作成した検索位置表示バーをマウスで操作する
category: swing
folder: BoundedRangeModel
tags: [JLabel, Icon, BoundedRangeModel, JScrollBar, JTable]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-02-17

## JLabelとIconで作成した検索位置表示バーをマウスで操作する
`JScrollBar`から`BoundedRangeModel`を取得し、`JLabel`と`Icon`で表示した検索位置表示バーをマウスで操作可能にします。

{% download %}

![screenshot](https://lh4.googleusercontent.com/-EN1vcmWX7Gs/UwDyGP5n91I/AAAAAAAACAE/tb9w7pHxtk8/s800/BoundedRangeModel.png)

### サンプルコード
<pre class="prettyprint"><code>class HighlightBarHandler extends MouseAdapter {
  private void processMouseEvent(MouseEvent e) {
    Point pt = e.getPoint();
    Component c = e.getComponent();
    BoundedRangeModel m = scrollbar.getModel();
    int h = m.getMaximum()-m.getMinimum();
    int iv = (int)(.5 - m.getExtent() * .5 + pt.y * h / (double)c.getHeight());
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

### 解説
- `Icon`に検索結果をハイライト表示し、`JLabel`に設定
    - この`JLabel`は、`JScrollPane`の子コンポーネントではないので、縦`JScrollBar`の`BoundedRangeModel`に`ChangeListener`を追加して、更新ごとに`JLabel`も`repaint`
- `JLabel`上の表示範囲をマウスで操作可能にするため、`MouseListener`などを追加
    - 位置は`JScrollBar`から`BoundedRangeModel`を取得して計算

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JScrollBarに検索結果をハイライト表示](http://terai.xrea.jp/Swing/ScrollBarSearchHighlighter.html)

<!-- dummy comment line for breaking list -->

### コメント
- ハイライトのサンプルとして`JTable`を使用しているけど、実際に行数が多くなるなら[JTableの検索結果をRowFilterとHighlighterで強調表示する](http://terai.xrea.jp/Swing/TableHighlightRegexFilter.html)のようにフィルタを使用するほうが良さそう。 -- [aterai](http://terai.xrea.jp/aterai.html) 2014-02-17 (月) 02:41:10

<!-- dummy comment line for breaking list -->
