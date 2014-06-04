---
layout: post
title: JListのアイテムをラバーバンドで複数選択、ドラッグ＆ドロップで並べ替え
category: swing
folder: DragSelectDropReordering
tags: [JList, TransferHandler, DragAndDrop, GlassPane, MouseListener, MouseMotionListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-10-13

## JListのアイテムをラバーバンドで複数選択、ドラッグ＆ドロップで並べ替え
`JList`のアイテムを、ラバーバンドで複数選択、ドラッグ＆ドロップで並べ替え可能にします。

{% download %}

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTL3XY_VqI/AAAAAAAAAYQ/RFVaD4w5C9w/s800/DragSelectDropReordering.png)

### サンプルコード
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

### 解説
上記のサンプルは、[JListのアイテムを範囲指定で選択](http://terai.xrea.jp/Swing/RubberBanding.html)と[TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](http://terai.xrea.jp/Swing/DnDReorderList.html)を使って、ラバーバンドによるアイテムの選択、ドラッグ＆ドロップでの並べ替えができるようになっています。

- 注: `javax.swing.TransferHandler.TransferSupport`などを使用しているので、`JDK 1.6.0`以上が必要

<!-- dummy comment line for breaking list -->


### 参考リンク
- [TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](http://terai.xrea.jp/Swing/DnDReorderList.html)
- [JListのアイテムを範囲指定で選択](http://terai.xrea.jp/Swing/RubberBanding.html)
- [XP Style Icons - Windows Application Icon, Software XP Icons](http://www.icongalore.com/)

<!-- dummy comment line for breaking list -->

### コメント
- Java勉強中の初心者です。コードの質問したいのですが、文字数がオーバします・・・・・ -- [java勉強中の初心者](http://terai.xrea.jp/java勉強中の初心者.html) 2013-04-23 (火) 11:08:46
    - ~~一番上にある「このページを編集する」から、制限無しで編集可能です。~~ スパムが鬱陶しいので編集禁止にしました(2014-05-16)。コードだけどこか別の場所(gist.github.comなど)に張り込んでリンクするのもいいかもしれません。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-04-23 (火) 12:15:08

<!-- dummy comment line for breaking list -->

