---
layout: post
category: swing
folder: DnDTabbedPane
title: JTabbedPaneのタブをドラッグ＆ドロップ
tags: [JTabbedPane, DragAndDrop, GlassPane, DragGestureListener]
author: aterai
pubdate: 2004-09-27T11:54:33+09:00
description: JTabbedPaneのタブをDrag&Dropで移動します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTLjYzYe0I/AAAAAAAAAXw/nr90t9LvfMI/s800/DnDTabbedPane.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2008/04/drag-and-drop-tabs-in-jtabbedpane.html
    lang: en
comments: true
---
## 概要
`JTabbedPane`のタブを`Drag&Drop`で移動します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTLjYzYe0I/AAAAAAAAAXw/nr90t9LvfMI/s800/DnDTabbedPane.png %}

## サンプルコード
<pre class="prettyprint"><code>protected int getTargetTabIndex(Point glassPt) {
  Point tabPt = SwingUtilities.convertPoint(glassPane, glassPt, this);
  boolean isTB = getTabPlacement() == JTabbedPane.TOP
              || getTabPlacement() == JTabbedPane.BOTTOM;
  Point d = isTB ? new Point(1, 0) : new Point(0, 1);
  for (int i = 0; i &lt; getTabCount(); i++) {
    Rectangle r = getBoundsAt(i);
    r.translate(-r.width * d.x / 2, -r.height * d.y / 2);
    if (r.contains(tabPt)) {
      return i;
    }
  }
  Rectangle r = getBoundsAt(getTabCount() - 1);
  r.translate(r.width * d.x / 2, r.height * d.y / 2);
  return r.contains(tabPt) ? getTabCount() : -1;
}

private void convertTab(int prev, int next) {
  if (next &lt; 0 || prev == next) {
    return;
  }
  Component cmp = getComponentAt(prev);
  Component tab = getTabComponentAt(prev);
  String str    = getTitleAt(prev);
  Icon icon     = getIconAt(prev);
  String tip    = getToolTipTextAt(prev);
  boolean flg   = isEnabledAt(prev);
  int tgtindex  = prev &gt; next ? next : next - 1;
  remove(prev);
  insertTab(str, icon, cmp, tip, tgtindex);
  setEnabledAt(tgtindex, flg);

  //When you drag'n'drop a disabled tab, it finishes enabled and selected.
  //pointed out by dlorde
  if (flg) {
    setSelectedIndex(tgtindex);
  }

  // I have a component in all tabs (jlabel with an X to close the tab)
  // and when i move a tab the component disappear.
  // pointed out by Daniel Dario Morales Salas
  setTabComponentAt(tgtindex, tab);
}
</code></pre>

## 解説
上記のサンプルでは、`JTabbedPane`のタブをドラッグすると、マウスカーソルが変更されて、ドロップ可能な位置に青い線を描画します。

- ドラッグ中、半透明のタブゴーストを表示するかどうかを切り替え可能
- タブ領域以外にドロップしようとすると、カーソルが変化
- `JTabbedPane`のタブが二段以上になる場合は未検証

<!-- dummy comment line for breaking list -->

`MouseMotionListener`と`MouseListener`ではなく、`DragGestureListener`、`DragSourceListener`、`DropTargetListener`を使用する方法に変更しました。

## 参考リンク
- [Java Swing Hacks #63 半透明のドラッグ＆ドロップ](https://www.oreilly.co.jp/books/4873112788/)
- [CardLayoutを使ってJTabbedPane風のコンポーネントを作成](https://ateraimemo.com/Swing/CardLayoutTabbedPane.html)
- [JTabbedPane間でタブのドラッグ＆ドロップ移動](https://ateraimemo.com/Swing/DnDExportTabbedPane.html)
- [JLayerを使ってJTabbedPaneのタブの挿入位置を描画する](https://ateraimemo.com/Swing/DnDLayerTabbedPane.html)

<!-- dummy comment line for breaking list -->

## コメント
- ドラッグ中のタブゴーストを表示する機能を追加しました。 -- *aterai* 2006-06-23 (金) 15:18:30
- `java.awt.dnd`パッケージを使用する方法にソースを変更しました。 -- *aterai* 2006-07-01 (土) 16:22:48
- `tab.setTabPlacement(JTabbedPane.RIGHT)`などへの対応と、タブのないタブエリアをドラッグすると`Exception`が発生していたのを修正しました。 -- *aterai* 2008-02-19 (火) 18:38:18
- `GlassPane`の設定方法を修正 -- *aterai* 2008-08-06 (水) 12:17:51
- 選択不可のタブを移動すると、選択可に変化するバグ(dlordeさんからの指摘、ありがとう)を修正。ついでにタブのアイコン、ツールチップにも対応。 -- *aterai* 2008-10-03 (金) 13:13:31
    - 選択不可のタブを移動不可にする場合は、`DragGestureListener#dragGestureRecognized`メソッドで`if(dragTabIndex<0 || !isEnabledAt(dragTabIndex)) return;`など。、 -- *aterai* 2008-10-03 (金) 13:15:18
- `SCROLL_TAB_LAYOUT`での、`auto scroll`テストを追加しました。 -- *aterai* 2008-12-09 (火) 12:49:10
- `SCROLL_TAB_LAYOUT`で、コンポーネントが`null`(`addTab("title", null)`などの場合)のタブをドラッグすると例外が発生するバグを修正(darylさんからの指摘、thx)。 -- *aterai* 2008-12-30 (火) 18:56:48
- タブのドラッグ中、`JTable`上などで`Cursor`が点滅するのを修正。 -- *aterai* 2009-05-19 (火) 17:16:44
- 参考にさせていただきました．ありがとうございます． -- *M.U* 2009-12-20 (日) 20:27:37
    - どういたしまして。 -- *aterai* 2009-12-21 (月) 00:43:51
- `WRAP_TAB_LAYOUT`でタブランの回転が発生した場合、目的外のタブがドラッグされるバグを修正(Arjenさんからの指摘) -- *aterai* 2019-11-06 (水) 21:16:49

<!-- dummy comment line for breaking list -->
