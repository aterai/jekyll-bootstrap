---
layout: post
title: Clipboardから文字列や画像を取得する
category: swing
folder: SystemClipboard
tags: [ServiceManager, ClipboardService, Transferable, JLabel]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-09-27

## Clipboardから文字列や画像を取得する
`Clipboard`から文字列や画像データを取得し、`JLabel`に表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTUB2-qFWI/AAAAAAAAAlY/hlwTEjnyC_g/s800/SystemClipboard.png)

### サンプルコード
<pre class="prettyprint"><code>private ClipboardService cs = null;
public JComponent makeUI() {
  try{
    cs = (ClipboardService)ServiceManager.lookup("javax.jnlp.ClipboardService");
  }catch(UnavailableServiceException e) {
    cs = null;
  }
  JPanel p = new JPanel(new BorderLayout());
  p.add(new JScrollPane(label));
  p.add(new JButton(new AbstractAction("get Clipboard DataFlavor") {
    @Override public void actionPerformed(ActionEvent e) {
      try {
        Transferable t = (cs==null)
          ?Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null)
          :cs.getContents();
        if(t==null) {
          java.awt.Toolkit.getDefaultToolkit().beep();
          return;
        }
        String str = "";
        ImageIcon image = null;
        if(t.isDataFlavorSupported(DataFlavor.imageFlavor)) {
          image = new ImageIcon((Image)t.getTransferData(DataFlavor.imageFlavor));
        }else if(t.isDataFlavorSupported(DataFlavor.stringFlavor)) {
          str = (String)t.getTransferData(DataFlavor.stringFlavor);
        }
        label.setText(str);
        label.setIcon(image);
      }catch(Exception ex) {
        ex.printStackTrace();
      }
    }
  }), BorderLayout.SOUTH);
  return p;
}
</code></pre>

### 解説
上記のサンプルを`Web Start`で実行した場合は、`Toolkit.getDefaultToolkit().getSystemClipboard().getContents(null)`ではなく、`ClipboardService#getContents()`を使って、`Transferable`を取得するようになっています。

- 文字列
    - `Transferable#getTransferData(DataFlavor.stringFlavor)`
- 画像
    - `Transferable#getTransferData(DataFlavor.imageFlavor)`

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Javaクリップボードメモ(Hishidama's Java Clipboard Memo)](http://www.ne.jp/asahi/hishidama/home/tech/java/clipboard.html)

<!-- dummy comment line for breaking list -->

### コメント
