---
layout: post
category: swing
folder: DnDBetweenLists
title: JList間でのドラッグ＆ドロップによるアイテムの移動
tags: [JList, DragAndDrop, TransferHandler]
author: aterai
pubdate: 2010-08-09T16:02:07+09:00
description: JList間でのドラッグ＆ドロップによるアイテムの移動や並べ替えを行います。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLUTkzH4I/AAAAAAAAAXY/tSQriEN1G_Y/s800/DnDBetweenLists.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2010/08/drag-and-drop-between-jlists.html
    lang: en
comments: true
---
## 概要
`JList`間でのドラッグ＆ドロップによるアイテムの移動や並べ替えを行います。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLUTkzH4I/AAAAAAAAAXY/tSQriEN1G_Y/s800/DnDBetweenLists.png %}

## サンプルコード
<pre class="prettyprint"><code>class ListItemTransferHandler extends TransferHandler {
  private JList source = null;
  @Override protected Transferable createTransferable(JComponent c) {
    source = (JList) c;
    indices = source.getSelectedIndices();
    transferedObjects = source.getSelectedValues();
    return new DataHandler(transferedObjects, localObjectFlavor.getMimeType());
  }
  @Override public boolean importData(TransferSupport info) {
    if (!canImport(info)) return false;
    JList target = (JList) info.getComponent();
    JList.DropLocation dl = (JList.DropLocation) info.getDropLocation();
    DefaultListModel listModel = (DefaultListModel) target.getModel();
    int index = dl.getIndex();
    int max = listModel.getSize();
    if (index &lt; 0 || index &gt; max) index = max;
    addIndex = index;
    try {
      Object[] values = (Object[]) info.getTransferable().getTransferData(localObjectFlavor);
      for (int i = 0; i &lt; values.length; i++) {
        int idx = index++;
        listModel.add(idx, values[i]);
        target.addSelectionInterval(idx, idx);
      }
      //----&gt;
      addCount = (target == source) ? values.length : 0;
      //&lt;----
      return true;
    } catch (UnsupportedFlavorException | IOException ex) {
      ex.printStackTrace();
    }
    return false;
  }
//......
</code></pre>

## 解説
上記のサンプルでは、一つの`JList`内でのアイテムの並べ替えを行う[TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](http://ateraimemo.com/Swing/DnDReorderList.html)を元に`ListItemTransferHandler`を作成し、`JList`間でのアイテム移動もできるようになっています。変更した箇所は、[TransferHandlerを使ってJTableの行をドラッグ＆ドロップ、並べ替え](http://ateraimemo.com/Swing/DnDReorderTable.html)から、[JTableの行を別のJTableにドラッグして移動](http://ateraimemo.com/Swing/DragRowsAnotherTable.html)と同じで、ドロップ先がドラッグ元と同じかどうかを調べて処理を変更しているだけです。

## 参考リンク
- [TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](http://ateraimemo.com/Swing/DnDReorderList.html)
- [JTableの行を別のJTableにドラッグして移動](http://ateraimemo.com/Swing/DragRowsAnotherTable.html)

<!-- dummy comment line for breaking list -->

## コメント
- アイテムをカット(<kbd>Ctrl+X</kbd>)すると`ClassCastException`が発生するのを修正。 -- *aterai* 2011-02-25 (金) 20:28:45

<!-- dummy comment line for breaking list -->
