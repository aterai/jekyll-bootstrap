---
layout: post
category: swing
folder: DraggableLinkButton
title: TransferHandlerでHyperlinkをブラウザにドロップ
tags: [DragAndDrop, TransferHandler, DataFlavor, Html, JButton]
author: aterai
pubdate: 2007-12-03T14:41:28+09:00
description: JButtonにTransferHandlerを設定して、ブラウザにリンクをドロップできるようにします。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTLyb41hvI/AAAAAAAAAYI/uoSzZ3thyWk/s800/DraggableLinkButton.png
comments: true
---
## 概要
`JButton`に`TransferHandler`を設定して、ブラウザにリンクをドロップできるようにします。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTLyb41hvI/AAAAAAAAAYI/uoSzZ3thyWk/s800/DraggableLinkButton.png %}

## サンプルコード
<pre class="prettyprint"><code>final String href = "http://ateraimemo.com/";
//final DataFlavor uriflavor = new DataFlavor(String.class, "text/uri-list");
final DataFlavor uriflavor = DataFlavor.stringFlavor;
JButton b = new JButton(href);
b.setTransferHandler(new TransferHandler("text") {
  @Override public boolean canImport(JComponent c, DataFlavor[] flavors) {
    return flavors.length &gt; 0 &amp;&amp; flavors[0].equals(uriflavor);
  }
  @Override public Transferable createTransferable(JComponent c) {
    return new Transferable() {
      @Override public Object getTransferData(DataFlavor flavor) {
        //System.out.println(flavor.getMimeType());
        return href;
      }
      @Override public DataFlavor[] getTransferDataFlavors() {
        return new DataFlavor[] { uriflavor };
      }
      @Override public boolean isDataFlavorSupported(DataFlavor flavor) {
        return flavor.equals(uriflavor);
      }
    };
  }
});
b.addMouseListener(new MouseAdapter() {
  @Override public void mousePressed(MouseEvent e) {
    JButton button = (JButton) e.getSource();
    TransferHandler handler = button.getTransferHandler();
    handler.exportAsDrag(button, e, TransferHandler.COPY);
  }
});
</code></pre>

## 解説
上記のサンプルでは、`URL`文字列を設定した`JButton`をマウスでドラッグし、ブラウザにドロップすると、そのサイトに移動することができます。

このような`URL`のドラッグ＆ドロップを実行するために、以下のような`TransferHandler`と`Transferable`を設定しています。

- 転送するプロパティー
    - `text`
- `DataFlavor`
    - `DataFlavor.stringFlavor`
- 転送するデータ
    - 文字列: `[http://ateraimemo.com/](http://ateraimemo.com/)`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Hyperlinkを、JLabel、JButton、JEditorPaneで表示](http://ateraimemo.com/Swing/HyperlinkLabel.html)
- [Java Swing「ドラッグ&ドロップ」メモ(Hishidama's Swing-TransferHandler Memo)](http://www.ne.jp/asahi/hishidama/home/tech/java/swing/TransferHandler.html)

<!-- dummy comment line for breaking list -->

## コメント
- `Opera`には、ドロップできないようです(`MIME`タイプを設定しないとダメ？)。 -- *aterai* 2007-12-03 (月) 14:41:28

<!-- dummy comment line for breaking list -->
