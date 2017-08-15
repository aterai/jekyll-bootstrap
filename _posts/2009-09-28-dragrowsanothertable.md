---
layout: post
category: swing
folder: DragRowsAnotherTable
title: JTableの行を別のJTableにドラッグして移動
tags: [JTable, DragAndDrop, TransferHandler, Cursor]
author: aterai
pubdate: 2009-09-28T14:28:36+09:00
description: JTableの行を別のJTableにDrag&Dropで移動します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTL05H70DI/AAAAAAAAAYM/YtTZHzrA2HU/s800/DragRowsAnotherTable.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2009/09/drag-rows-from-one-jtable-to-another.html
    lang: en
comments: true
---
## 概要
`JTable`の行を別の`JTable`に`Drag & Drop`で移動します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTL05H70DI/AAAAAAAAAYM/YtTZHzrA2HU/s800/DragRowsAnotherTable.png %}

## サンプルコード
<pre class="prettyprint"><code>class TableRowTransferHandler extends TransferHandler {
  private final DataFlavor localObjectFlavor;
  private int[] indices;
  private int addIndex = -1; //Location where items were added
  private int addCount; //Number of items added.
  private JComponent source;
  public TableRowTransferHandler() {
    super();
    localObjectFlavor = new ActivationDataFlavor(
        Object[].class,
        DataFlavor.javaJVMLocalObjectMimeType, "Array of items");
  }
  @Override protected Transferable createTransferable(JComponent c) {
    source = c;
    JTable table = (JTable) c;
    DefaultTableModel model = (DefaultTableModel) table.getModel();
    List&lt;Object&gt; list = new ArrayList&lt;&gt;();
    indices = table.getSelectedRows();
    for (int i : indices) {
      list.add(model.getDataVector().elementAt(i));
    }
    Object[] transferedObjects = list.toArray();
    return new DataHandler(
        transferedObjects, localObjectFlavor.getMimeType());
  }
  @Override public boolean canImport(TransferSupport info) {
    JTable table = (JTable) info.getComponent();
    boolean isDroppable = info.isDrop()
      &amp;&amp; info.isDataFlavorSupported(localObjectFlavor);
    //XXX bug?
    table.setCursor(isDroppable ? DragSource.DefaultMoveDrop
                                : DragSource.DefaultMoveNoDrop);
    return isDroppable;
  }
  @Override public int getSourceActions(JComponent c) {
    return TransferHandler.MOVE; //TransferHandler.COPY_OR_MOVE;
  }
  @Override public boolean importData(TransferSupport info) {
    if (!canImport(info)) {
      return false;
    }
    TransferHandler.DropLocation tdl = info.getDropLocation();
    if (!(tdl instanceof JTable.DropLocation)) {
      return false;
    }
    JTable.DropLocation dl = (JTable.DropLocation) tdl;
    JTable target = (JTable) info.getComponent();
    DefaultTableModel model = (DefaultTableModel) target.getModel();
    int index = dl.getRow();
    //boolean insert = dl.isInsert();
    int max = model.getRowCount();
    if (index &lt; 0 || index &gt; max) {
      index = max;
    }
    addIndex = index;
    target.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
    try {
      Object[] values =
        (Object[]) info.getTransferable().getTransferData(localObjectFlavor);
      if (Objects.equals(source, target)) {
        addCount = values.length;
      }
      for (int i = 0; i &lt; values.length; i++) {
        int idx = index++;
        model.insertRow(idx, (Vector) values[i]);
        target.getSelectionModel().addSelectionInterval(idx, idx);
      }
      return true;
    } catch (UnsupportedFlavorException | IOException ex) {
      ex.printStackTrace();
    }
    return false;
  }
  @Override protected void exportDone(
      JComponent c, Transferable data, int action) {
    cleanup(c, action == MOVE);
  }
  private void cleanup(JComponent c, boolean remove) {
    if (remove &amp;&amp; indices != null) {
      c.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
      DefaultTableModel model = (DefaultTableModel) ((JTable) c).getModel();
      if (addCount &gt; 0) {
        for (int i = 0; i &lt; indices.length; i++) {
          if (indices[i] &gt;= addIndex) {
            indices[i] += addCount;
          }
        }
      }
      for (int i = indices.length - 1; i &gt;= 0; i--) {
        model.removeRow(indices[i]);
      }
    }
    indices = null;
    addCount = 0;
    addIndex = -1;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`1`つの`JTable`内で行の並べ替えを行う[TransferHandlerを使ってJTableの行をドラッグ＆ドロップ、並べ替え](http://ateraimemo.com/Swing/DnDReorderTable.html)を元に、複数`JTable`間で行移動が可能になるよう`TableRowTransferHandler`を拡張しています。

- - - -
以下のように、`JTable#setFillsViewportHeight(true)`で[JTable自体の高さを拡張](http://ateraimemo.com/Swing/FillsViewportHeight.html)しておかないと、`JTable`が空の状態でドロップが不可になります。

<pre class="prettyprint"><code>TransferHandler handler = new TableRowTransferHandler();
table.getSelectionModel().setSelectionMode(
    ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
table.setTransferHandler(handler);
table.setDropMode(DropMode.INSERT_ROWS);
table.setDragEnabled(true);
table.setFillsViewportHeight(true);
</code></pre>

- - - -
`WindowsLookAndFeel`でカーソルのチラつき防止のために、`TransferHandler#canImport(...)`内で`JTable#setCursor(...)`をしているため、デスクトップなどからファイルをドラッグしてドロップ不可カーソルが表示されると、その後マウスをリリースしてもカーソルが表示されたままになるバグがあります。

また、このサンプルでは、各`JTable`に`TableRowSorter`などが設定され、ソートされた状態での並べ替えは想定していません。

## 参考リンク
- [JTableの行をドラッグ＆ドロップ](http://ateraimemo.com/Swing/DnDTable.html)
- [TransferHandlerを使ってJTableの行をドラッグ＆ドロップ、並べ替え](http://ateraimemo.com/Swing/DnDReorderTable.html)

<!-- dummy comment line for breaking list -->

## コメント
