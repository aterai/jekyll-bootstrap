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
    href: https://java-swing-tips.blogspot.com/2010/08/drag-and-drop-between-jlists.html
    lang: en
comments: true
---
## 概要
`JList`間でのドラッグ＆ドロップによるアイテムの移動や並べ替えを行います。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLUTkzH4I/AAAAAAAAAXY/tSQriEN1G_Y/s800/DnDBetweenLists.png %}

## サンプルコード
<pre class="prettyprint"><code>class ListItemTransferHandler extends TransferHandler {
  protected final DataFlavor localObjectFlavor;
  protected JList&lt;?&gt; source;
  protected int[] indices;
  protected int addIndex = -1;
  protected int addCount;

  protected ListItemTransferHandler() {
    super();
    localObjectFlavor = new DataFlavor(List.class, "List of items");
  }
  @Override protected Transferable createTransferable(JComponent c) {
    source = (JList&lt;?&gt;) c;
    indices = source.getSelectedIndices();
    List&lt;?&gt; transferredObjects = source.getSelectedValuesList();
    return new Transferable() {
      @Override public DataFlavor[] getTransferDataFlavors() {
        return new DataFlavor[] {localObjectFlavor};
      }
      @Override public boolean isDataFlavorSupported(DataFlavor flavor) {
        return Objects.equals(localObjectFlavor, flavor);
      }
      @Override public Object getTransferData(DataFlavor flavor)
          throws UnsupportedFlavorException, IOException {
        if (isDataFlavorSupported(flavor)) {
          return transferredObjects;
        } else {
          throw new UnsupportedFlavorException(flavor);
        }
      }
    };
  }
  @Override public boolean canImport(TransferHandler.TransferSupport info) {
    return info.isDrop() &amp;&amp; info.isDataFlavorSupported(localObjectFlavor);
  }
  @Override public int getSourceActions(JComponent c) {
    return TransferHandler.MOVE;
  }
  @SuppressWarnings("unchecked")
  @Override public boolean importData(TransferHandler.TransferSupport info) {
    TransferHandler.DropLocation tdl = info.getDropLocation();
    if (!canImport(info) || !(tdl instanceof JList.DropLocation)) {
      return false;
    }
    JList.DropLocation dl = (JList.DropLocation) tdl;
    JList&lt;?&gt; target = (JList&lt;?&gt;) info.getComponent();
    DefaultListModel listModel = (DefaultListModel) target.getModel();
    int max = listModel.getSize();
    int index = dl.getIndex();
    index = index &lt; 0 ? max : index;
    index = Math.min(index, max);
    addIndex = index;
    try {
      List&lt;?&gt; values = (List&lt;?&gt;) info.getTransferable().getTransferData(
        localObjectFlavor);
      for (Object o : values) {
        int i = index++;
        listModel.add(i, o);
        target.addSelectionInterval(i, i);
      }
      // ----&gt;
      addCount = target.equals(source) ? values.size() : 0;
      // &lt;----
      return true;
    } catch (UnsupportedFlavorException | IOException ex) {
      ex.printStackTrace();
    }
    return false;
  }
  // ...
</code></pre>

## 解説
上記のサンプルでは、一つの`JList`内でのアイテムの並べ替えを行う[TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](https://ateraimemo.com/Swing/DnDReorderList.html)を元に`ListItemTransferHandler`を作成し、`JList`間でのアイテム移動も可能にしています。

- ドロップ先がドラッグ元と同じコンポーネントかどうかを調査する処理を変更
    - [TransferHandlerを使ってJTableの行をドラッグ＆ドロップ、並べ替え](https://ateraimemo.com/Swing/DnDReorderTable.html)から[JTableの行を別のJTableにドラッグして移動](https://ateraimemo.com/Swing/DragRowsAnotherTable.html)と同様

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](https://ateraimemo.com/Swing/DnDReorderList.html)
- [JTableの行を別のJTableにドラッグして移動](https://ateraimemo.com/Swing/DragRowsAnotherTable.html)

<!-- dummy comment line for breaking list -->

## コメント
- リストアイテムをカット(<kbd>Ctrl+X</kbd>)すると`ClassCastException`が発生するバグを修正。 -- *aterai* 2011-02-25 (金) 20:28:45

<!-- dummy comment line for breaking list -->
