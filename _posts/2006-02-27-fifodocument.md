---
layout: post
category: swing
folder: FIFODocument
title: JTextAreaに表示できる行数を制限
tags: [JTextArea, DocumentListener]
author: aterai
pubdate: 2006-02-27T11:11:21+09:00
description: ドキュメントのサイズを一定にして、JTextAreaなど表示できる行数を制限します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMafjL8xI/AAAAAAAAAZI/-KMSGPcn0jM/s800/FIFODocument.png
comments: true
---
## 概要
ドキュメントのサイズを一定にして、`JTextArea`など表示できる行数を制限します。[Swing (Archive) - JTextArea Memory Overflow ??](https://community.oracle.com/thread/1479784)にあるソースコードを参考にしています。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTMafjL8xI/AAAAAAAAAZI/-KMSGPcn0jM/s800/FIFODocument.png %}

## サンプルコード
<pre class="prettyprint"><code>jta.setEditable(false);
jta.getDocument().addDocumentListener(new DocumentListener() {
  @Override public void insertUpdate(DocumentEvent e) {
    final Document doc = jta.getDocument();
    final Element root = doc.getDefaultRootElement();
    if (root.getElementCount() &lt;= maxLines) return;
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        removeLines(doc, root);
      }
    });
    jta.setCaretPosition(doc.getLength());
  }
  private void removeLines(Document doc, Element root) {
    Element fl = root.getElement(0);
    try {
      doc.remove(0, fl.getEndOffset());
    } catch (BadLocationException ble) {
      System.out.println(ble);
    }
  }
  @Override public void removeUpdate(DocumentEvent e) {}
  @Override public void changedUpdate(DocumentEvent e) {}
});
final Timer timer = new Timer(100, new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    String s = new Date().toString();
    jta.append((jta.getDocument().getLength() &gt; 0) ? "\n" + s : s);
  }
});
</code></pre>

## 解説
上記のサンプルでは、`1`行追加した時に規定の行数を越えている場合、先頭の`1`行を削除する`DocumentListener`を作成し、これを`JTextArea`に設定しています。

- `10`行以上になると先頭行から削除
- 複数行テキストのペーストには未対応
    - 参考: [Swing (Archive) - JTextArea Memory Overflow ??](https://community.oracle.com/thread/1479784)は、複数行貼り込みに対応している
- `DocumentListener`ではなく、以下のような`DocumentFilter`を設定する方法もある
    
    <pre class="prettyprint"><code>((AbstractDocument) ta.getDocument()).setDocumentFilter(new FIFODocumentFilter());
    // ...
    class FIFODocumentFilter extends DocumentFilter {
      private static final int MAX_LINES = 10;
      @Override public void insertString(
          DocumentFilter.FilterBypass fb, int offset,
          String string, AttributeSet attr)
          throws BadLocationException {
        fb.insertString(offset, string, attr);
        Element root = fb.getDocument().getDefaultRootElement();
        if (root.getElementCount() &gt; MAX_LINES) {
          fb.remove(0, root.getElement(0).getEndOffset());
        }
      }
    }
</code></pre>
- * 参考リンク [#reference]
- [Swing (Archive) - JTextArea Memory Overflow ??](https://community.oracle.com/thread/1479784)

<!-- dummy comment line for breaking list -->

## コメント
- `sample`実行できないよ -- *cinik* 2006-11-16 (木) 01:09:03
    - `jnlp`ファイルの名前を`sample`から`example`に変更しているので、一旦キャッシュを消してみるとうまくいくかもしれません。(そうではなく`Exception`などが発生しているのでしょうか？) -- *aterai* 2006-11-16 (木) 12:39:54

<!-- dummy comment line for breaking list -->
