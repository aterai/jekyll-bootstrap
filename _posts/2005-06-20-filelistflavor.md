---
layout: post
title: Fileのドラッグ＆ドロップ
category: swing
folder: FileListFlavor
tags: [DragAndDrop, JTable, DropTargetListener, TransferHandler]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-06-20

## Fileのドラッグ＆ドロップ
`Windows`などからファイルを`JTable`にドラッグ＆ドロップします。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTMhxsIIsI/AAAAAAAAAZU/iZ6Pn8yTFFM/s800/FileListFlavor.png)

### サンプルコード
<pre class="prettyprint"><code>DropTargetListener dtl = new DropTargetAdapter() {
  @Override public void dragOver(DropTargetDragEvent dtde) {
    if(dtde.isDataFlavorSupported(DataFlavor.javaFileListFlavor)) {
      dtde.acceptDrag(DnDConstants.ACTION_COPY);
      return;
    }
    dtde.rejectDrag();
  }
  @Override public void drop(DropTargetDropEvent dtde) {
    try {
      if(dtde.isDataFlavorSupported(DataFlavor.javaFileListFlavor)) {
        dtde.acceptDrop(DnDConstants.ACTION_COPY);
        Transferable t = dtde.getTransferable();
        java.util.List list = (java.util.List)t.getTransferData(
                                 DataFlavor.javaFileListFlavor);
        for(Object o: list) {
          if(o instanceof File) {
            File f = (File) o;
            model.addTest(new Test(f.getName(),f.getAbsolutePath()));
          }
        }
        dtde.dropComplete(true);
        return;
      }
    }catch(UnsupportedFlavorException ufe) {
      ufe.printStackTrace();
    }catch(IOException ioe) {
      ioe.printStackTrace();
    }
    dtde.rejectDrop();
  }
};
DropTarget dt = new DropTarget(tbl,DnDConstants.ACTION_COPY,dtl,true);
</code></pre>

### 解説
`Windows`のエクスプローラなどからファイルを選択(複数可)し、上記のサンプルアプリ上にドラッグ＆ドロップするとファイル名などを`JTable`に表示しています。

ドロップされた`DataFlavor`が、`DataFlavor.javaFileListFlavor`の場合だけ、これをファイルとして処理する`DropTargetListener`を作成しています。

- - - -
`JDK 1.6.0`以降なら、以下のような`TransferHandler`を作成して使用する方法もあります。

- [JTableでファイルとディレクトリを別々にソート](http://terai.xrea.jp/Swing/FileDirectoryComparator.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>table.setDropMode(DropMode.INSERT_ROWS);
table.setTransferHandler(new FileTransferHandler());
</code></pre>

<pre class="prettyprint"><code>class FileTransferHandler extends TransferHandler {
  @Override public boolean importData(TransferSupport support) {
    try{
      if(canImport(support)) {
        JTable table = (JTable)support.getComponent();
        DefaultTableModel model = (DefaultTableModel)table.getModel();
        for(Object o: (List)support.getTransferable().getTransferData(
            DataFlavor.javaFileListFlavor)) {
          if(o instanceof File) {
            File file = (File)o;
            model.addRow(new Object[] {
                file, file.length(), file.getAbsolutePath()});
          }
        }
        return true;
      }
    }catch(Exception ex) {
      ex.printStackTrace();
    }
    return false;
  }
  @Override public boolean canImport(TransferSupport support) {
    return support.isDataFlavorSupported(DataFlavor.javaFileListFlavor);
  }
}
</code></pre>

### 参考リンク
- [Java2: WindowsからのDrag and Drop](http://www5.big.or.jp/~tera/Labo/Java2/j2dnd.html)
- [java drag and drop](http://www.ne.jp/asahi/j.nihei/personal/linuxDragDrop.html)
- [JTable自体の高さを拡張](http://terai.xrea.jp/Swing/FillsViewportHeight.html)

<!-- dummy comment line for breaking list -->

### コメント
