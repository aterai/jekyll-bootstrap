---
layout: post
category: swing
folder: DragSource
title: FileをJavaアプリケーションからドロップ
tags: [DragAndDrop, File, DragGestureListener, TransferHandler]
author: aterai
pubdate: 2005-11-14T21:13:08+09:00
description: JavaアプリケーションからWindowsのデスクトップなどにFileをドロップします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTL5-PTzWI/AAAAAAAAAYU/G2P--5GJWSU/s800/DragSource.png
comments: true
---
## 概要
`Java`アプリケーションから`Windows`のデスクトップなどに`File`をドロップします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTL5-PTzWI/AAAAAAAAAYU/G2P--5GJWSU/s800/DragSource.png %}

## サンプルコード
<pre class="prettyprint"><code>class MyDragGestureListener implements DragGestureListener {
  @Override public void dragGestureRecognized(DragGestureEvent dge) {
    final File tmpfile = getFile();
    if (tmpfile == null) {
      return;
    }
    Transferable tran = new Transferable() {
      @Override public Object getTransferData(DataFlavor flavor) {
        ArrayList al = new ArrayList(1);
        al.add(tmpfile);
        return al;
      }
      @Override public DataFlavor[] getTransferDataFlavors() {
        return new DataFlavor[] { DataFlavor.javaFileListFlavor };
      }
      @Override public boolean isDataFlavorSupported(DataFlavor flavor) {
        return flavor.equals(DataFlavor.javaFileListFlavor);
      }
    };
    DragSourceAdapter dsa = new DragSourceAdapter() {
      @Override public void dragDropEnd(DragSourceDropEvent dsde) {
        if (dsde.getDropSuccess()) {
          clearFile();
        }
      }
    };
    dge.startDrag(DragSource.DefaultMoveDrop, tran, dsa);
  }
}
</code></pre>

## 解説
上記のサンプルでは、ボタンで空の一時ファイルを生成し、中央のラベルをマウスでドラッグすると生成したファイルをデスクトップなどに移動できます。

以下のように`DragGestureListener`を登録してラベルをドラッグ＆ドロップすることで、`JFileChooser`などで書き出すフォルダなどを指定する手間が省いています。

<pre class="prettyprint"><code>DragSource dragSource = DragSource.getDefaultDragSource();
dragSource.createDefaultDragGestureRecognizer(label,
       DnDConstants.ACTION_MOVE, new MyDragGestureListener());
</code></pre>

- - - -
`JDK 1.6.0`以上なら、以下のような`TransferHandler`を使用する方法もあります。

<pre class="prettyprint"><code>label.setTransferHandler(new TransferHandler() {
  @Override public int getSourceActions(JComponent c) {
    return TransferHandler.COPY_OR_MOVE;
  }
  @Override protected Transferable createTransferable(JComponent c) {
    File tmpfile = getFile();
    if (tmpfile == null) {
      return null;
    } else {
      return new TempFileTransferable(tmpfile);
    }
  }
  @Override protected void exportDone(JComponent c, Transferable d, int a) {
    cleanup(c, a == MOVE);
  }
  private void cleanup(JComponent c, boolean removeFile) {
    if (removeFile) {
      clearFile();
      c.repaint();
    }
  }
});
label.addMouseListener(new MouseAdapter() {
  @Override public void mousePressed(MouseEvent e) {
    System.out.println(e);
    JComponent c = (JComponent) e.getSource();
    c.getTransferHandler().exportAsDrag(c, e, TransferHandler.COPY);
  }
});
</code></pre>

## 参考リンク
- [opus-i | シンプル素材 テンプレート 音楽素材](http://opus-i.biz/)

<!-- dummy comment line for breaking list -->

## コメント
