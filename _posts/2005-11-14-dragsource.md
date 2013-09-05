---
layout: post
title: FileをJavaアプリケーションからドロップ
category: swing
folder: DragSource
tags: [DragAndDrop, File, DragGestureListener, TransferHandler]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-11-14

## FileをJavaアプリケーションからドロップ
`Java`アプリケーションから`Windows`のデスクトップなどに`File`をドロップします。

- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTL5-PTzWI/AAAAAAAAAYU/G2P--5GJWSU/s800/DragSource.png)

### サンプルコード
<pre class="prettyprint"><code>class MyDragGestureListener implements DragGestureListener {
  @Override public void dragGestureRecognized(DragGestureEvent dge) {
    final File tmpfile = getFile();
    if(tmpfile==null) {
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
        if(dsde.getDropSuccess()) {
          clearFile();
        }
      }
    };
    dge.startDrag(DragSource.DefaultMoveDrop, tran, dsa);
  }
}
</code></pre>

### 解説
上記のサンプルでは、ボタンで空の一時ファイルを生成し、ラベルをマウスでドラッグすると生成したファイルをデスクトップなどに移動することが出来ます。

以下のように`DragGestureListener`を登録してラベルをドラッグ＆ドロップすることで、`JFileChooser`などで書き出すフォルダなどを指定する手間が省いています。

<pre class="prettyprint"><code>DragSource dragSource = DragSource.getDefaultDragSource();
dragSource.createDefaultDragGestureRecognizer(label,
       DnDConstants.ACTION_MOVE, new MyDragGestureListener());
</code></pre>

- - - -
`JDK 1.6.0`以上なら、以下のような`TransferHandler`を`JLabel`に設定する方法もあります。

<pre class="prettyprint"><code>label.setTransferHandler(new TransferHandler() {
  @Override public int getSourceActions(JComponent c) {
    return COPY_OR_MOVE;
  }
  @Override protected Transferable createTransferable(JComponent c) {
    File tmpfile = getFile();
    if(tmpfile==null) {
      return null;
    }else{
      return new TempFileTransferable(tmpfile);
    }
  }
  @Override protected void exportDone(JComponent c, Transferable d, int a) {
    cleanup(c, a == MOVE);
  }
  private void cleanup(JComponent c, boolean removeFile) {
    if(removeFile) {
      clearFile();
      c.repaint();
    }
  }
});
label.addMouseListener(new MouseAdapter() {
  @Override public void mousePressed(MouseEvent e) {
    System.out.println(e);
    JComponent c = (JComponent)e.getSource();
    c.getTransferHandler().exportAsDrag(c, e, TransferHandler.COPY);
  }
});
</code></pre>

### 参考リンク
- [opus-i | シンプル素材 テンプレート 音楽素材](http://opus-i.biz/)

<!-- dummy comment line for breaking list -->

### コメント