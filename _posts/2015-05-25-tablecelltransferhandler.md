---
layout: post
category: swing
folder: TableCellTransferHandler
title: JTableのセルを選択してJListにドラッグ＆ドロップでIconをコピーする
tags: [JTable, JList, DragAndDrop, TransferHandler, Icon]
author: aterai
pubdate: 2015-05-25T00:03:51+09:00
description: JTableのセルを選択可能にし、ドラッグ＆ドロップでそのセル内のIconをJListにコピーできるようにTransferHandlerを設定します。
comments: true
---
## 概要
`JTable`のセルを選択可能にし、ドラッグ＆ドロップでそのセル内の`Icon`を`JList`にコピーできるように`TransferHandler`を設定します。

{% download https://lh3.googleusercontent.com/-TUrxk7yYqYM/VWHkR1mENvI/AAAAAAAAN4w/bEU29WIgjOE/s800/TableCellTransferHandler.png %}

## サンプルコード
<pre class="prettyprint"><code>//DataFlavor FLAVOR = new ActivationDataFlavor(JTable.class, DataFlavor.javaJVMLocalObjectMimeType, "JTable");
class CellIconTransferHandler extends TransferHandler {
  private final DataFlavor localObjectFlavor;
  public CellIconTransferHandler(DataFlavor flavor) {
    super();
    localObjectFlavor = flavor;
  }
  @Override protected Transferable createTransferable(JComponent c) {
    JTable table = (JTable) c;
    if (table.getSelectedColumn() != 1) {
      return null;
    }
    return new DataHandler(table, localObjectFlavor.getMimeType());
  }
  @Override public boolean canImport(TransferSupport info) {
    return false;
  }
  @Override public int getSourceActions(JComponent c) {
    return COPY;
  }
}

class TableCellTransferHandler extends TransferHandler {
  private final DataFlavor localObjectFlavor;
  public TableCellTransferHandler(DataFlavor flavor) {
    super();
    localObjectFlavor = flavor;
  }
  @Override public boolean canImport(TransferSupport info) {
    Component c = info.getComponent();
    if (c instanceof JList) {
      return info.isDrop() &amp;&amp; info.isDataFlavorSupported(localObjectFlavor);
    }
    return false;
  }
  @Override public int getSourceActions(JComponent c) {
    return TransferHandler.COPY;
  }
  @SuppressWarnings("unchecked")
  @Override public boolean importData(TransferSupport info) {
    if (!canImport(info)) {
      return false;
    }
    JList l = (JList) info.getComponent();
    try {
      Object o = info.getTransferable().getTransferData(localObjectFlavor);
      if (o instanceof JTable) {
        JTable t = (JTable) o;
        Object obj = t.getValueAt(t.getSelectedRow(), t.getSelectedColumn());
        ((DefaultListModel) l.getModel()).addElement(obj);
      }
      return true;
    } catch (UnsupportedFlavorException | IOException ex) {
      ex.printStackTrace();
    }
    return false;
  }
}
</code></pre>

## 解説
上記のサンプルでは、ドラッグ元の`JTable`に`CellIconTransferHandler`を設定して特定の列のアイコンのみドラッグ可能にし、ドロップ先の`JList`には`TableCellTransferHandler`を設定してアイコンを受け取り(実際は`JTable`ごと受け取って選択されたアイコンを取得)、これを一行で表示しています。

- テスト
    - `clear`ボタン: `JList`にドロップされたアイコンをクリア
    - `filter`ボタン: `JList`にドロップされたアイコンを含む行のみ表示するフィルタを`JTable`に設定

<!-- dummy comment line for breaking list -->

## コメント
