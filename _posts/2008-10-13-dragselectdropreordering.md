---
layout: post
category: swing
folder: DragSelectDropReordering
title: JListのアイテムをラバーバンドで複数選択、ドラッグ＆ドロップで並べ替え
tags: [JList, TransferHandler, DragAndDrop, GlassPane, MouseListener, MouseMotionListener]
author: aterai
pubdate: 2008-10-13T16:02:09+09:00
description: JListのアイテムを、ラバーバンドで複数選択、ドラッグ＆ドロップで並べ替え可能にします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTL3XY_VqI/AAAAAAAAAYQ/RFVaD4w5C9w/s800/DragSelectDropReordering.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2008/10/rubber-band-selection-drag-and-drop.html
    lang: en
comments: true
---
## 概要
`JList`のアイテムを、ラバーバンドで複数選択、ドラッグ＆ドロップで並べ替え可能にします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTL3XY_VqI/AAAAAAAAAYQ/RFVaD4w5C9w/s800/DragSelectDropReordering.png %}

## サンプルコード
<pre class="prettyprint"><code>JList list = new JList(model);
list.setLayoutOrientation(JList.HORIZONTAL_WRAP);
list.setVisibleRowCount(0);
list.setFixedCellWidth(62);
list.setFixedCellHeight(62);
list.setCellRenderer(new IconListCellRenderer());
RubberBandingListener rbl = new RubberBandingListener();
list.addMouseMotionListener(rbl);
list.addMouseListener(rbl);
list.getSelectionModel().setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
list.setTransferHandler(new ListItemTransferHandler());
list.setDropMode(DropMode.INSERT);
</code></pre>

## 解説
上記のサンプルは、[JListのアイテムを範囲指定で選択](https://ateraimemo.com/Swing/RubberBanding.html)と[TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](https://ateraimemo.com/Swing/DnDReorderList.html)を適用し、`JList`でラバーバンドによるアイテムの選択、ドラッグ＆ドロップによるアイテム並べ替えが可能です。

- 注: `javax.swing.TransferHandler.TransferSupport`などを使用しているので、`JDK 1.6.0`以上が必要

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](https://ateraimemo.com/Swing/DnDReorderList.html)
- [JListのアイテムを範囲指定で選択](https://ateraimemo.com/Swing/RubberBanding.html)
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)

<!-- dummy comment line for breaking list -->

## コメント
- Java勉強中の初心者です。コードの質問したいのですが、文字数がオーバします・・・ -- *java勉強中の初心者* 2013-04-23 (火) 11:08:46
    - コードだけどこか別の場所(`gist.github.com`など)に張り込んでリンクするといいかもしれません。 -- *aterai* 2013-04-23 (火) 12:15:08

<!-- dummy comment line for breaking list -->
