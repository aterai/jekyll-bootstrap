---
layout: post
title: JTabbedPaneのタブをドラッグ＆ドロップ
category: swing
folder: DnDTabbedPane
tags: [JTabbedPane, DragAndDrop, GlassPane, DragGestureListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-09-27

## JTabbedPaneのタブをドラッグ＆ドロップ
`JTabbedPane`のタブを`Drag&Drop`で移動します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTLjYzYe0I/AAAAAAAAAXw/nr90t9LvfMI/s800/DnDTabbedPane.png)

### サンプルコード
<pre class="prettyprint"><code>private int getTargetTabIndex(Point glassPt) {
  Point tabPt = SwingUtilities.convertPoint(glassPane, glassPt, DnDTabbedPane.this);
  boolean isTB = getTabPlacement()==JTabbedPane.TOP || getTabPlacement()==JTabbedPane.BOTTOM;
  for(int i=0;i&lt;getTabCount();i++) {
    Rectangle r = getBoundsAt(i);
    if(isTB) r.setRect(r.x-r.width/2, r.y,  r.width, r.height);
    else     r.setRect(r.x, r.y-r.height/2, r.width, r.height);
    if(r.contains(tabPt)) return i;
  }
  Rectangle r = getBoundsAt(getTabCount()-1);
  if(isTB) r.setRect(r.x+r.width/2, r.y,  r.width, r.height);
  else     r.setRect(r.x, r.y+r.height/2, r.width, r.height);
  return   r.contains(tabPt)?getTabCount():-1;
}

private void convertTab(int prev, int next) {
  if(next&lt;0 || prev==next) {
    return;
  }
  Component cmp = getComponentAt(prev);
  Component tab = getTabComponentAt(prev);
  String str    = getTitleAt(prev);
  Icon icon     = getIconAt(prev);
  String tip    = getToolTipTextAt(prev);
  boolean flg   = isEnabledAt(prev);
  int tgtindex  = prev&gt;next ? next : next-1;
  remove(prev);
  insertTab(str, icon, cmp, tip, tgtindex);
  setEnabledAt(tgtindex, flg);

  //When you drag'n'drop a disabled tab, it finishes enabled and selected.
  //pointed out by dlorde
  if(flg) setSelectedIndex(tgtindex);

  // I have a component in all tabs (jlabel with an X to close the tab)
  // and when i move a tab the component disappear.
  // pointed out by Daniel Dario Morales Salas
  setTabComponentAt(tgtindex, tab);
}
</code></pre>

### 解説
上記のサンプルでは、`JTabbedPane`のタブをドラッグすると、マウスカーソルが変更されて、ドロップ可能な位置に青い線を描画します。

ドラッグ中、半透明のタブゴーストを表示するかどうかを切り替えることが出来ます。タブ領域以外にドロップしようとすると、カーソルが変化します。`JTabbedPane`のタブが二段以上になる場合の検証はほとんどしていません。

`MouseMotionListener`と`MouseListener`ではなく、`DragGestureListener`、`DragSourceListener`、`DropTargetListener`を使用する方法に変更しました。

### 参考リンク
- [Java Swing Hacks #63 半透明のドラッグ＆ドロップ](http://www.oreilly.co.jp/books/4873112788/toc.html)
- [CardLayoutを使ってJTabbedPane風のコンポーネントを作成](http://terai.xrea.jp/Swing/CardLayoutTabbedPane.html)
- [JTabbedPane間でタブのドラッグ＆ドロップ移動](http://terai.xrea.jp/Swing/DnDExportTabbedPane.html)
- [JLayerを使ってJTabbedPaneのタブの挿入位置を描画する](http://terai.xrea.jp/Swing/DnDLayerTabbedPane.html)

<!-- dummy comment line for breaking list -->

### コメント
- ドラッグ中のタブゴーストを表示する機能を追加しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-06-23 (金) 15:18:30
- `java.awt.dnd`パッケージを使用する方法にソースを変更しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-07-01 (土) 16:22:48
- `tab.setTabPlacement(JTabbedPane.RIGHT)`などへの対応と、タブのないタブエリアをドラッグすると`Exception`が発生していたのを修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-02-19 (火) 18:38:18
- `GlassPane`の設定方法を修正 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-08-06 (水) 12:17:51
- 選択不可のタブを移動すると、選択可に変化するバグ(dlordeさんからの指摘、ありがとう)を修正。ついでにタブのアイコン、ツールチップにも対応。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-10-03 (金) 13:13:31
    - 選択不可のタブを移動不可にする場合は、`DragGestureListener#dragGestureRecognized`メソッドで`if(dragTabIndex<0 || !isEnabledAt(dragTabIndex)) return;`など。、 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-10-03 (金) 13:15:18
- `SCROLL_TAB_LAYOUT`での、`auto scroll`テストを追加しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-12-09 (火) 12:49:10
- `SCROLL_TAB_LAYOUT`で、コンポーネントが`null`(`addTab("title", null)`などの場合)のタブをドラッグすると例外が発生するバグを修正(darylさんからの指摘、thx)。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-12-30 (火) 18:56:48
- タブのドラッグ中、`JTable`上などで`Cursor`が点滅するのを修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-05-19 (火) 17:16:44
- 参考にさせていただきました．ありがとうございます． -- [M.U](http://terai.xrea.jp/M.U.html) 2009-12-20 (日) 20:27:37
    - どういたしまして。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-12-21 (月) 00:43:51

<!-- dummy comment line for breaking list -->
