---
layout: post
category: swing
folder: SmoothScroll
title: JTextAreaでSmoothScrollによる行移動
tags: [JScrollPane, JViewport, Animation, JTextArea]
author: aterai
pubdate: 2007-08-13T13:01:23+09:00
description: SmoothScrollアニメーション有りでJTextAreaの任意の行まで移動します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTTSaxFSzI/AAAAAAAAAkI/KtedLqwCXBY/s800/SmoothScroll.png
comments: true
---
## 概要
`SmoothScroll`アニメーション有りで`JTextArea`の任意の行まで移動します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTTSaxFSzI/AAAAAAAAAkI/KtedLqwCXBY/s800/SmoothScroll.png %}

## サンプルコード
<pre class="prettyprint"><code>Document doc = textArea.getDocument();
Element root = doc.getDefaultRootElement();
int ln = getDestLineNumber(textField, root);
if (ln &lt; 0) {
  Toolkit.getDefaultToolkit().beep();
  return;
}
try {
  final Element elem = root.getElement(ln - 1);
  final Rectangle dest = textArea.modelToView(elem.getStartOffset());
  final Rectangle current = scroll.getViewport().getViewRect();
  new Timer(20, new ActionListener() {
    @Override public void actionPerformed(ActionEvent ae) {
      Timer animator = (Timer) ae.getSource();
      if (dest.y &lt; current.y &amp;&amp; animator.isRunning()) {
        int d = Math.max(1, (current.y - dest.y) / 2);
        current.y = current.y - d;
        textArea.scrollRectToVisible(current);
      } else if (dest.y &gt; current.y &amp;&amp; animator.isRunning()) {
        int d = Math.max(1, (dest.y - current.y) / 2);
        current.y = current.y + d;
        textArea.scrollRectToVisible(current);
      } else {
        textArea.setCaretPosition(elem.getStartOffset());
        animator.stop();
      }
    }
  }).start();
} catch (BadLocationException ble) {
  Toolkit.getDefaultToolkit().beep();
}
</code></pre>

## 解説
上記のサンプルでは、`java.swing.Timer`でイベントを発生させ、`scrollRectToVisible(...)`メソッドを使用して目的位置と現在位置の差の半分だけ`ViewRect`のスクロールを繰り返すことで行移動アニメーションを行っています。

## 参考リンク
- [JTextAreaの任意の行に移動](https://ateraimemo.com/Swing/GotoLine.html)

<!-- dummy comment line for breaking list -->

## コメント
