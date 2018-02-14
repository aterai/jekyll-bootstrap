---
layout: post
category: swing
folder: DnDReorderList
title: TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え
tags: [JList, TransferHandler, DragAndDrop]
author: aterai
pubdate: 2008-09-29T13:33:14+09:00
description: JListのアイテムを複数選択し、ドラッグ＆ドロップで並べ替えを可能にするTransferHandlerを作成します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTLeSCyHuI/AAAAAAAAAXo/v2OLiSPdgEY/s800/DnDReorderList.png
comments: true
---
## 概要
`JList`のアイテムを複数選択し、ドラッグ＆ドロップで並べ替えを可能にする`TransferHandler`を作成します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTLeSCyHuI/AAAAAAAAAXo/v2OLiSPdgEY/s800/DnDReorderList.png %}

## サンプルコード
<pre class="prettyprint"><code>class ListItemTransferHandler extends TransferHandler {
  protected final DataFlavor localObjectFlavor;
  protected int[] indices;
  protected int addIndex = -1; // Location where items were added
  protected int addCount; // Number of items added.

  protected ListItemTransferHandler() {
    super();
    localObjectFlavor = new DataFlavor(List.class, "List of items");
  }
  @Override protected Transferable createTransferable(JComponent c) {
    JList&lt;?&gt; source = (JList&lt;?&gt;) c;
    indices = source.getSelectedIndices();
    List&lt;?&gt; transferedObjects = source.getSelectedValuesList();
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
          return transferedObjects;
        } else {
          throw new UnsupportedFlavorException(flavor);
        }
      }
    };
  }
  @Override public boolean canImport(TransferSupport info) {
    return info.isDrop() &amp;&amp; info.isDataFlavorSupported(localObjectFlavor);
  }
  @Override public int getSourceActions(JComponent c) {
    return TransferHandler.MOVE; // TransferHandler.COPY_OR_MOVE;
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
    // boolean insert = dl.isInsert();
    int max = listModel.getSize();
    int index = dl.getIndex();
    // If it is out of range, it is appended to the end
    index = index &lt; 0 ? max : index;
    index = Math.min(index, max);
    addIndex = index;
    try {
      List&lt;?&gt; values = (List&lt;?&gt;) info.getTransferable()
        .getTransferData(localObjectFlavor);
      for (Object o : values) {
        int i = index++;
        listModel.add(i, o);
        target.addSelectionInterval(i, i);
      }
      addCount = values.size();
      return true;
    } catch (UnsupportedFlavorException | IOException ex) {
      ex.printStackTrace();
    }
    return false;
  }
  @Override protected void exportDone(
      JComponent c, Transferable data, int action) {
    cleanup(c, action == TransferHandler.MOVE);
  }
  private void cleanup(JComponent c, boolean remove) {
    if (remove &amp;&amp; Objects.nonNull(indices)) {
      // If we are moving items around in the same list, we
      // need to adjust the indices accordingly, since those
      // after the insertion point have moved.
      if (addCount &gt; 0) {
        for (int i = 0; i &lt; indices.length; i++) {
          if (indices[i] &gt;= addIndex) {
            indices[i] += addCount;
          }
        }
      }
      JList&lt;?&gt; source = (JList&lt;?&gt;) c;
      DefaultListModel model = (DefaultListModel) source.getModel();
      for (int i = indices.length - 1; i &gt;= 0; i--) {
        model.remove(indices[i]);
      }
    }
    indices = null;
    addCount = 0;
    addIndex = -1;
  }
}
</code></pre>

## 解説
上記のサンプルの`TransferHandler`は、主に[Drag and Drop and Data Transfer: Examples (The Java™ Tutorials > Creating a GUI with JFC/Swing > Drag and Drop and Data Transfer)](https://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/index.html#BasicDnD)の[ListTransferHandler.java](https://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/DropDemoProject/src/dnd/ListTransferHandler.java)を参考にして作成しています。ただし、この`ListTransferHandler.java`は項目を複数選択して、`JList`内での並べ替えは想定していない(もしくはバグ？)ようなので、`importData(...)`メソッドや、`cleanup()`メソッドを修正しています。

<pre class="prettyprint"><code>JList list = new JList(listModel);
list.getSelectionModel().setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
list.setTransferHandler(new ListItemTransferHandler());
list.setDropMode(DropMode.INSERT);
list.setDragEnabled(true);
</code></pre>

- `importData`
    - 使用されていない？`importString(...)`の内容をこちらに移動
- `cleanup`
    - 例えば、項目`0`,`1`,`2`を複数選択して、`1`と`2`の間にドロップすると、`1`,`2`,`2`になるので、以下のように修正
        
        <pre class="prettyprint"><code>for (int i = 0; i &lt; indices.length; i++) {
          //　if (indices[i] &gt; addIndex) {
          if (indices[i] &gt;= addIndex) {
        //　...
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
[JListの項目をドラッグ＆ドロップ](https://ateraimemo.com/Swing/DnDList.html)とは異なり、複数アイテムを選択して`Drag&Drop`による移動が可能になっています。

## 参考リンク
- [Drag and Drop and Data Transfer: Examples (The Java™ Tutorials > Creating a GUI with JFC/Swing > Drag and Drop and Data Transfer)](https://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/index.html#BasicDnD)
    - [ListTransferHandler.java](https://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/DropDemoProject/src/dnd/ListTransferHandler.java)
- [JListの項目をドラッグ＆ドロップ](https://ateraimemo.com/Swing/DnDList.html)
- [JListのアイテムをラバーバンドで複数選択、ドラッグ＆ドロップで並べ替え](https://ateraimemo.com/Swing/DragSelectDropReordering.html)

<!-- dummy comment line for breaking list -->

## コメント
- 複数選択して選択されたアイテムのインデックスに移動した場合、複写されるバグ？を修正。 -- *aterai* 2008-10-10 (金) 21:44:34

<!-- dummy comment line for breaking list -->
