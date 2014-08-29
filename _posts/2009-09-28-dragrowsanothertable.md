---
layout: post
title: JTableの行を別のJTableにドラッグして移動
category: swing
folder: DragRowsAnotherTable
tags: [JTable, DragAndDrop, TransferHandler, Cursor]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-09-28

## JTableの行を別のJTableにドラッグして移動
`JTable`の行を別の`JTable`に`Drag&Drop`で移動します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTL05H70DI/AAAAAAAAAYM/YtTZHzrA2HU/s800/DragRowsAnotherTable.png %}

### サンプルコード
<pre class="prettyprint"><code>class TableRowTransferHandler extends TransferHandler {
  private int[] rows    = null;
  private int addIndex  = -1; //Location where items were added
  private int addCount  = 0;  //Number of items added.
  private final DataFlavor localObjectFlavor;
  private Object[] transferedObjects = null;
  private JComponent source = null;
  public TableRowTransferHandler() {
    localObjectFlavor = new ActivationDataFlavor(
      Object[].class, DataFlavor.javaJVMLocalObjectMimeType, "Array of items");
  }
  @Override protected Transferable createTransferable(JComponent c) {
    source = c;
    JTable table = (JTable) c;
    DefaultTableModel model = (DefaultTableModel)table.getModel();
    List&lt;Object&gt; list = new ArrayList&lt;&gt;();
    for(int i: rows = table.getSelectedRows())
      list.add(model.getDataVector().elementAt(i));
    transferedObjects = list.toArray();
    return new DataHandler(transferedObjects,localObjectFlavor.getMimeType());
  }
  @Override public boolean canImport(TransferSupport info) {
    JTable t = (JTable)info.getComponent();
    boolean b = info.isDrop()&amp;&amp;info.isDataFlavorSupported(localObjectFlavor);
    //XXX bug?
    t.setCursor(b?DragSource.DefaultMoveDrop:DragSource.DefaultMoveNoDrop);
    return b;
  }
  @Override public int getSourceActions(JComponent c) {
    return COPY_OR_MOVE;
  }
  @Override public boolean importData(TransferSupport info) {
    JTable target = (JTable)info.getComponent();
    JTable.DropLocation dl = (JTable.DropLocation)info.getDropLocation();
    DefaultTableModel model = (DefaultTableModel)target.getModel();
    int index = dl.getRow();
    int max = model.getRowCount();
    if(index&lt;0 || index&gt;max) index = max;
    addIndex = index;
    target.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
    try {
      Object[] values =
        (Object[])info.getTransferable().getTransferData(localObjectFlavor);
      if(source==target) addCount = values.length;
      for(int i=0;i&lt;values.length;i++) {
        int idx = index++;
        model.insertRow(idx, (Vector)values[i]);
        target.getSelectionModel().addSelectionInterval(idx, idx);
      }
      return true;
    }catch(Exception ufe) { ufe.printStackTrace(); }
    return false;
  }
  @Override protected void exportDone(JComponent c, Transferable t, int act) {
    cleanup(c, act == MOVE);
  }
  private void cleanup(JComponent src, boolean remove) {
    if(remove &amp;&amp; rows != null) {
      JTable table = (JTable)src;
      src.setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
      DefaultTableModel model = (DefaultTableModel)table.getModel();
      if(addCount &gt; 0) {
        for(int i=0;i&lt;rows.length;i++) {
          if(rows[i]&gt;=addIndex) { rows[i] += addCount; }
        }
      }
      for(int i=rows.length-1;i&gt;=0;i--) model.removeRow(rows[i]);
    }
    rows     = null;
    addCount = 0;
    addIndex = -1;
  }
}
</code></pre>

### 解説
上記のサンプルでは、一つの`JTable`内での行の並べ替えを行う[TransferHandlerを使ってJTableの行をドラッグ＆ドロップ、並べ替え](http://terai.xrea.jp/Swing/DnDReorderTable.html)を元に`TableRowTransferHandler`を作成し、`JTable`間での行移動もできるようになっています。

- - - -
以下のように、`JTable#setFillsViewportHeight(true)`で、[JTable自体の高さを拡張](http://terai.xrea.jp/Swing/FillsViewportHeight.html)しておかないと、行が一つもない状態でドロップができなくなります。

<pre class="prettyprint"><code>TransferHandler handler = new TableRowTransferHandler();
table.getSelectionModel().setSelectionMode(
            ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
table.setTransferHandler(handler);
table.setDropMode(DropMode.INSERT_ROWS);
table.setDragEnabled(true);
table.setFillsViewportHeight(true);
</code></pre>

- - - -
`WindowsLookAndFeel`でカーソルのチラつき防止のために、`TransferHandler#canImport(...)`内で`JTable#setCursor(...)`をしているため、デスクトップなどからファイルをドラッグしてドロップ不可カーソルが表示されるとマウスをリリースしたあともそのカーソルが表示されたままになるバグがあります。

また、このサンプルでは、各`JTable`に`TableRowSorter`などが設定され、ソートされた状態での並べ替えは想定していません。

### 参考リンク
- [JTableの行をドラッグ＆ドロップ](http://terai.xrea.jp/Swing/DnDTable.html)
- [TransferHandlerを使ってJTableの行をドラッグ＆ドロップ、並べ替え](http://terai.xrea.jp/Swing/DnDReorderTable.html)

<!-- dummy comment line for breaking list -->

### コメント
