---
layout: post
category: swing
folder: SystemClipboard
title: Clipboardから文字列や画像を取得する
tags: [ServiceManager, Clipboard, Transferable, JLabel]
author: aterai
pubdate: 2010-09-27T15:53:12+09:00
description: Clipboardから文字列や画像データを取得し、JLabelに表示します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTUB2-qFWI/AAAAAAAAAlY/hlwTEjnyC_g/s800/SystemClipboard.png
comments: true
---
## 概要
`Clipboard`から文字列や画像データを取得し、`JLabel`に表示します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTUB2-qFWI/AAAAAAAAAlY/hlwTEjnyC_g/s800/SystemClipboard.png %}

## サンプルコード
<pre class="prettyprint"><code>private ClipboardService cs = null;
public JComponent makeUI() {
  try {
    cs = (ClipboardService) ServiceManager.lookup("javax.jnlp.ClipboardService");
  } catch (UnavailableServiceException e) {
    cs = null;
  }
  JPanel p = new JPanel(new BorderLayout());
  p.add(new JScrollPane(label));
  p.add(new JButton(new AbstractAction("get Clipboard DataFlavor") {
    @Override public void actionPerformed(ActionEvent e) {
      try {
        Transferable t = (cs == null)
          ? Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null)
          : cs.getContents();
        if (t == null) {
          Toolkit.getDefaultToolkit().beep();
          return;
        }
        String str = "";
        ImageIcon image = null;
        if (t.isDataFlavorSupported(DataFlavor.imageFlavor)) {
          image = new ImageIcon((Image) t.getTransferData(DataFlavor.imageFlavor));
        } else if (t.isDataFlavorSupported(DataFlavor.stringFlavor)) {
          str = (String) t.getTransferData(DataFlavor.stringFlavor);
        }
        label.setText(str);
        label.setIcon(image);
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    }
  }), BorderLayout.SOUTH);
  return p;
}
</code></pre>

## 解説
- `Web Start`で実行:
    - `ClipboardService#getContents()`を使って`Transferable`を取得
- ローカル環境で実行:
    - `Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null)`を使って`Transferable`を取得

<!-- dummy comment line for breaking list -->

- - - -
- `Transferable`から文字列を取得
    - `Transferable#getTransferData(DataFlavor.stringFlavor)`
- `Transferable`から画像を取得
    - `Transferable#getTransferData(DataFlavor.imageFlavor)`

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Clipboard (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/datatransfer/Clipboard.html)
- [Javaクリップボードメモ(Hishidama's Java Clipboard Memo)](https://www.ne.jp/asahi/hishidama/home/tech/java/clipboard.html)

<!-- dummy comment line for breaking list -->

## コメント
