---
layout: post
title: TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え
category: swing
folder: DnDReorderList
tags: [JList, TransferHandler, DragAndDrop]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-09-29

## TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え
`JList`のアイテムを複数選択し、ドラッグ＆ドロップで並べ替えを可能にする`TransferHandler`を作成します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTLeSCyHuI/AAAAAAAAAXo/v2OLiSPdgEY/s800/DnDReorderList.png %}

### サンプルコード
<pre class="prettyprint"><code>class ListItemTransferHandler extends TransferHandler {
  private final DataFlavor localObjectFlavor;
  private Object[] transferedObjects = null;
  public ListItemTransferHandler() {
    localObjectFlavor = new ActivationDataFlavor(
      Object[].class, DataFlavor.javaJVMLocalObjectMimeType, "Array of items");
  }
  @Override protected Transferable createTransferable(JComponent c) {
    JList list = (JList) c;
    indices = list.getSelectedIndices();
    transferedObjects = list.getSelectedValues();
    return new DataHandler(transferedObjects, localObjectFlavor.getMimeType());
  }
  @Override public boolean canImport(TransferSupport info) {
    if (!info.isDrop() || !info.isDataFlavorSupported(localObjectFlavor)) {
      return false;
    }
    return true;
  }
  @Override public int getSourceActions(JComponent c) {
    return TransferHandler.MOVE; //TransferHandler.COPY_OR_MOVE;
  }
  @Override public boolean importData(TransferSupport info) {
    if (!canImport(info)) {
      return false;
    }
    JList target = (JList)info.getComponent();
    JList.DropLocation dl = (JList.DropLocation)info.getDropLocation();
    DefaultListModel listModel = (DefaultListModel)target.getModel();
    int index = dl.getIndex();
    //boolean insert = dl.isInsert();
    int max = listModel.getSize();
    if(index&lt;0 || index&gt;max) {
      index = max;
    }
    addIndex = index;

    try {
      Object[] values = (Object[])info.getTransferable().getTransferData(localObjectFlavor);
      addCount = values.length;
      for(int i=0;i&lt;values.length;i++) {
        int idx = index++;
        listModel.add(idx, values[i]);
        target.addSelectionInterval(idx, idx);
      }
      return true;
    }catch(UnsupportedFlavorException ufe) {
      ufe.printStackTrace();
    }catch(java.io.IOException ioe) {
      ioe.printStackTrace();
    }
    return false;
  }
  @Override protected void exportDone(JComponent c, Transferable data, int action) {
    cleanup(c, action == TransferHandler.MOVE);
  }
  private void cleanup(JComponent c, boolean remove) {
    if(remove &amp;&amp; indices != null) {
      JList source = (JList)c;
      DefaultListModel model  = (DefaultListModel)source.getModel();
      if(addCount &gt; 0) {
        for(int i=0;i&lt;indices.length;i++) {
          if(indices[i]&gt;=addIndex) {
            indices[i] += addCount;
          }
        }
      }
      for(int i=indices.length-1;i&gt;=0;i--) {
        model.remove(indices[i]);
      }
    }
    indices  = null;
    addCount = 0;
    addIndex = -1;
  }
  private int[] indices = null;
  private int addIndex  = -1; //Location where items were added
  private int addCount  = 0;  //Number of items added.
}
</code></pre>

### 解説
上記のサンプルの`TransferHandler`は、主に[Drag and Drop and Data Transfer: Examples (The Java™ Tutorials > Creating a GUI with JFC/Swing > Drag and Drop and Data Transfer)](http://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/index.html#BasicDnD)の[ListTransferHandler.java](http://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/DropDemoProject/src/dnd/ListTransferHandler.java)を参考にして作成しています。ただし、この`ListTransferHandler.java`は項目を複数選択して、`JList`内での並べ替えは想定していない？(もしくはバグ)ようなので、`importData(...)`メソッドや、`cleanup()`メソッドをすこし変更しています。

<pre class="prettyprint"><code>JList list = new JList(listModel);
list.getSelectionModel().setSelectionMode(ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
list.setTransferHandler(new ListItemTransferHandler());
list.setDropMode(DropMode.INSERT);
list.setDragEnabled(true);
</code></pre>

- `importData`
    - 使用されていない？`importString(...)`の内容をこちらに移動

<!-- dummy comment line for breaking list -->

- `cleanup`
    - 例えば、項目`0`,`1`,`2`を複数選択して、`1`と`2`の間にドロップすると、`1`,`2`,`2`になる

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>for(int i=0;i&lt;indices.length;i++) {
  //if(indices[i]&gt;addIndex) {
  if(indices[i]&gt;=addIndex) {
//...
</code></pre>

- - - -
[JListの項目をドラッグ＆ドロップ](http://terai.xrea.jp/Swing/DnDList.html)とは異なり、複数アイテムを選択して`Drag&Drop`による移動が可能になっています。

### 参考リンク
- [Drag and Drop and Data Transfer: Examples (The Java™ Tutorials > Creating a GUI with JFC/Swing > Drag and Drop and Data Transfer)](http://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/index.html#BasicDnD)
    - [ListTransferHandler.java](http://docs.oracle.com/javase/tutorial/uiswing/examples/dnd/DropDemoProject/src/dnd/ListTransferHandler.java)
- [JListの項目をドラッグ＆ドロップ](http://terai.xrea.jp/Swing/DnDList.html)
- [JListのアイテムをラバーバンドで複数選択、ドラッグ＆ドロップで並べ替え](http://terai.xrea.jp/Swing/DragSelectDropReordering.html)

<!-- dummy comment line for breaking list -->

### コメント
- 複数選択して選択されたアイテムのインデックスに移動した場合、複写されるバグ？を修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-10-10 (金) 21:44:34

<!-- dummy comment line for breaking list -->

