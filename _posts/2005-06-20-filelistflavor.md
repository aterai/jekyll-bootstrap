---
layout: post
category: swing
folder: FileListFlavor
title: Fileのドラッグ＆ドロップ
tags: [DragAndDrop, JTable, DropTargetListener, TransferHandler]
author: aterai
pubdate: 2005-06-20
description: WindowsなどからファイルをJTableにドラッグ＆ドロップします。
comments: true
---
## 概要
`Windows`などからファイルを`JTable`にドラッグ＆ドロップします。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTMhxsIIsI/AAAAAAAAAZU/iZ6Pn8yTFFM/s800/FileListFlavor.png %}

## サンプルコード
<pre class="prettyprint"><code>final FileModel model = new FileModel();
final JTable table = new JTable(model);
DropTargetListener dtl = new DropTargetAdapter() {
  @Override public void dragOver(DropTargetDragEvent dtde) {
    if (dtde.isDataFlavorSupported(DataFlavor.javaFileListFlavor)) {
      dtde.acceptDrag(DnDConstants.ACTION_COPY);
      return;
    }
    dtde.rejectDrag();
  }
  @Override public void drop(DropTargetDropEvent dtde) {
    try {
      if (dtde.isDataFlavorSupported(DataFlavor.javaFileListFlavor)) {
        dtde.acceptDrop(DnDConstants.ACTION_COPY);
        Transferable transferable = dtde.getTransferable();
        List list = (List) transferable.getTransferData(
            DataFlavor.javaFileListFlavor);
        for (Object o: list) {
          if (o instanceof File) {
            File file = (File) o;
            model.addFileName(
                new FileName(file.getName(), file.getAbsolutePath()));
          }
        }
        dtde.dropComplete(true);
        return;
      }
    } catch (UnsupportedFlavorException | IOException ex) {
      ex.printStackTrace();
    }
    dtde.rejectDrop();
  }
};
new DropTarget(table, DnDConstants.ACTION_COPY, dtl, true);
</code></pre>

## 解説
`Windows`のエクスプローラなどからファイルを選択(複数可)し、上記のサンプルアプリ上にドラッグ＆ドロップするとファイル名などを`JTable`に表示しています。

ドロップされた`DataFlavor`が、`DataFlavor.javaFileListFlavor`の場合だけ、これをファイルとして処理する`DropTargetListener`を作成しています。

- - - -
`JDK 1.6.0`以降なら、以下のような`TransferHandler`を作成して使用する方法もあります。

- [JTableでファイルとディレクトリを別々にソート](http://ateraimemo.com/Swing/FileDirectoryComparator.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>table.setDropMode(DropMode.INSERT_ROWS);
table.setTransferHandler(new FileTransferHandler());
</code></pre>

<pre class="prettyprint"><code>class FileTransferHandler extends TransferHandler {
  @Override public boolean importData(TransferSupport support) {
    try {
      if (canImport(support)) {
        JTable table = (JTable) support.getComponent();
        DefaultTableModel model = (DefaultTableModel) table.getModel();
        for (Object o: (List) support.getTransferable().getTransferData(
            DataFlavor.javaFileListFlavor)) {
          if (o instanceof File) {
            File file = (File) o;
            model.addRow(new Object[] {
                file, file.length(), file.getAbsolutePath()
            });
          }
        }
        return true;
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return false;
  }
  @Override public boolean canImport(TransferSupport support) {
    return support.isDataFlavorSupported(DataFlavor.javaFileListFlavor);
  }
}
</code></pre>

## 参考リンク
- [Java2: WindowsからのDrag and Drop](http://www5.big.or.jp/~tera/Labo/Java2/j2dnd.html)
- [java drag and drop](http://www.ne.jp/asahi/j.nihei/personal/linuxDragDrop.html)
- [JTable自体の高さを拡張](http://ateraimemo.com/Swing/FillsViewportHeight.html)

<!-- dummy comment line for breaking list -->

## コメント
