---
layout: post
category: swing
folder: DropOnTabTitle
title: JTabbedPaneのタブ上にリストアイテムをドロップ
tags: [JTabbedPane, JList, DragAndDrop]
author: aterai
pubdate: 2014-10-27T00:01:06+09:00
description: JTabbedPaneのタブ上にドロップすることで、選択しているListItemをそのタブ内にあるJListへ移動します。
image: https://lh5.googleusercontent.com/-oMjKQSnXvmM/VEzg70T1BQI/AAAAAAAANnU/Exu8u5wYyAw/s800/DropOnTabTitle.png
comments: true
---
## 概要
`JTabbedPane`のタブ上にドロップすることで、選択している`ListItem`をそのタブ内にある`JList`へ移動します。

{% download https://lh5.googleusercontent.com/-oMjKQSnXvmM/VEzg70T1BQI/AAAAAAAANnU/Exu8u5wYyAw/s800/DropOnTabTitle.png %}

## サンプルコード
<pre class="prettyprint"><code>new DropTarget(jtp, DnDConstants.ACTION_MOVE, new DropTargetListener() {
  private int targetTabIndex = -1;
  @Override public void dropActionChanged(DropTargetDragEvent e) {}
  @Override public void dragExit(DropTargetEvent e) {}
  @Override public void dragEnter(DropTargetDragEvent e) {}
  @Override public void dragOver(DropTargetDragEvent e) {
    if (isDropAcceptable(e)) {
      e.acceptDrag(e.getDropAction());
    } else {
      e.rejectDrag();
    }
    repaint();
  }
  @SuppressWarnings("unchecked")
  @Override public void drop(DropTargetDropEvent e) {
    try {
      Transferable t = e.getTransferable();
      DataFlavor[] f = t.getTransferDataFlavors();
      JList&lt;String&gt; sourceList = (JList&lt;String&gt;) t.getTransferData(f[0]);
      JList&lt;String&gt; targetList = listArray.get(targetTabIndex);
      DefaultListModel&lt;String&gt; tm =
        (DefaultListModel&lt;String&gt;) targetList.getModel();
      DefaultListModel&lt;String&gt; sm =
        (DefaultListModel&lt;String&gt;) sourceList.getModel();

      int[] indices = sourceList.getSelectedIndices();
      for (int j = indices.length - 1; j &gt;= 0; j--) {
        tm.addElement(sm.remove(indices[j]));
      }
      e.dropComplete(true);
    } catch (UnsupportedFlavorException | IOException ie) {
      e.dropComplete(false);
    }
  }
  private boolean isDropAcceptable(DropTargetDragEvent e) {
    Transferable t = e.getTransferable();
    DataFlavor[] f = t.getTransferDataFlavors();
    Point pt = e.getLocation();
    targetTabIndex = -1;
    for (int i = 0; i &lt; jtp.getTabCount(); i++) {
      if (jtp.getBoundsAt(i).contains(pt)) {
        targetTabIndex = i;
        break;
      }
    }
    return targetTabIndex &gt;= 0
      &amp;&amp; targetTabIndex != jtp.getSelectedIndex()
      &amp;&amp; t.isDataFlavorSupported(f[0]);
  }
}, true);
</code></pre>

## 解説
上記のサンプルでは、`DropTarget`として`JTabbedPane`を指定し、`DropTargetListener#dragOver(...)`メソッドをオーバーライドして、マウスのドラッグポイントがそのタブ上(現在選択されているタブ以外)にある場合のみドロップ可能になるように設定しています。

ドロップの可・不可は、`DropTargetDragEvent#acceptDrag(...)`、`DropTargetDragEvent#rejectDrag()`メソッドで切り替えることができます。

## 参考リンク
- [JListの項目をドラッグ＆ドロップ](https://ateraimemo.com/Swing/DnDList.html)
    - 上記のリンク先コメントからこのサンプルは分離、作成した

<!-- dummy comment line for breaking list -->

## コメント
