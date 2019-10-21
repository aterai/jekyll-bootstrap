---
layout: post
category: swing
folder: DropFileOnFileChooser
title: JFileChooserにTransferHandlerを設定してFileをドロップ可能にする
tags: [JFileChooser, TransferHandler, File, DragAndDrop]
author: aterai
pubdate: 2019-10-21T16:31:38+09:00
description: JFileChooserにTransferHandlerを設定してFileやDirectoryをドロップ可能にします。
image: https://drive.google.com/uc?id=1NA-vGQgCHGvMjG9nrxYwpTVuYCIgeFFZ
comments: true
---
## 概要
`JFileChooser`に`TransferHandler`を設定して`File`や`Directory`をドロップ可能にします。

{% download https://drive.google.com/uc?id=1NA-vGQgCHGvMjG9nrxYwpTVuYCIgeFFZ %}

## サンプルコード
<pre class="prettyprint"><code>chooser.setTransferHandler(new FileChooserTransferHandler());
// ...
class FileChooserTransferHandler extends TransferHandler {
  @Override public boolean canImport(TransferSupport support) {
    boolean canDrop = support.isDataFlavorSupported(DataFlavor.javaFileListFlavor);
    boolean isTarget = support.getComponent() instanceof JFileChooser;
    return support.isDrop() &amp;&amp; canDrop &amp;&amp; isTarget; // &amp;&amp; !isMultiSelection;
  }

  @Override public boolean importData(TransferSupport support) {
    try {
      JFileChooser fc = (JFileChooser) support.getComponent();
      List&lt;?&gt; list = (List&lt;?&gt;) support.getTransferable().getTransferData(DataFlavor.javaFileListFlavor);
      File[] files = new File[list.size()];
      for (int i = 0; i &lt; list.size(); i++) {
        files[i] = (File) list.get(i);
      }
      if (fc.isMultiSelectionEnabled()) {
        fc.setSelectedFiles(files);
      } else {
        File f = files[0];
        if (f.isDirectory()) {
          fc.setCurrentDirectory(f);
        } else {
          fc.setSelectedFile(f);
        }
      }
      return true;
    } catch (IOException | UnsupportedFlavorException ex) {
      return false;
    }
  }
}
</code></pre>

## 解説
- `Default`
    - `JFileChooser`の`JTextField`に文字列がドロップ可能だが、ファイルはドロップ不可
- `TransferHandler`
    - `JFileChooser`内の`JTable`、`JList`、`JTextField`以外にファイルをドロップ可能にする`TransferHandler`を設定
    - `JFileChooser#setMultiSelectionEnabled(true)`の場合、選択された複数ファイル(ディレクトリを除く)のファイル名が`JTextField`に表示される
    - `JFileChooser#setMultiSelectionEnabled(false)`の場合、選択された複数ファイルの先頭ファイルがドロップの対象になる
        - ドロップの対象ファイルがディレクトリの場合、`JFileChooser#setCurrentDirectory(dir)`でカレントディレクトリを変更
        - ドロップの対象ファイルがファイルの場合、`JFileChooser#setSelectedFile(file)`で選択ファイルを変更

<!-- dummy comment line for breaking list -->

- - - -
- 以下のように`TransferHandler#canImport(...)`をオーバーライドして複数ファイルが選択されている場合はドロップを拒否すると、`InvalidDnDOperationException: No drop current`が発生する？

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class FileChooserTransferHandler extends TransferHandler {
  @Override public boolean canImport(TransferSupport support) {
    boolean canDrop = support.isDataFlavorSupported(DataFlavor.javaFileListFlavor);
    boolean isTarget = support.getComponent() instanceof JFileChooser;
    boolean isMultiSelection = true;
    if (isTarget &amp;&amp; canDrop) {
      try {
        JFileChooser fc = (JFileChooser) support.getComponent();
        // XXX: java.awt.dnd.InvalidDnDOperationException: No drop current
        List&lt;?&gt; list = (List&lt;?&gt;) support.getTransferable().getTransferData(DataFlavor.javaFileListFlavor);
        isMultiSelection = list.size() != 1;
      } catch (IOException | UnsupportedFlavorException ex) {
        ex.printStackTrace();
      }
    }
    return support.isDrop() &amp;&amp; canDrop &amp;&amp; isTarget &amp;&amp; !isMultiSelection;
  }
</code></pre>

## 参考リンク
- [JFileChooserを開いた時のカレントディレクトリを設定する - Java Swing Tips](https://ateraimemo.com/https://ateraimemo.com/Swing/FileChooserCurrentDirectory.html)

<!-- dummy comment line for breaking list -->

## コメント
