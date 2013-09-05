---
layout: post
title: JTextAreaでSmoothScrollによる行移動
category: swing
folder: SmoothScroll
tags: [JScrollPane, JViewport, Animation, JTextArea]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-08-13

## JTextAreaでSmoothScrollによる行移動
`SmoothScroll`アニメーション有りで任意の行まで移動します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTTSaxFSzI/AAAAAAAAAkI/KtedLqwCXBY/s800/SmoothScroll.png)

### サンプルコード
<pre class="prettyprint"><code>Document doc = textArea.getDocument();
Element root = doc.getDefaultRootElement();
int ln = getDestLineNumber(textField, root);
if(ln&lt;0) { Toolkit.getDefaultToolkit().beep(); return; }
try{
  final Element elem = root.getElement(ln-1);
  final Rectangle dest = textArea.modelToView(elem.getStartOffset());
  final Rectangle current = scroll.getViewport().getViewRect();
  new Timer(20, new ActionListener() {
    @Override public void actionPerformed(ActionEvent ae) {
      Timer animator = (Timer)ae.getSource();
      if(dest.y &lt; current.y &amp;&amp; animator.isRunning()) {
        int d = Math.max(1, (current.y-dest.y)/2);
        current.y = current.y - d;
        textArea.scrollRectToVisible(current);
      }else if(dest.y &gt; current.y &amp;&amp; animator.isRunning()) {
        int d = Math.max(1, (dest.y-current.y)/2);
        current.y = current.y + d;
        textArea.scrollRectToVisible(current);
      }else{
        textArea.setCaretPosition(elem.getStartOffset());
        animator.stop();
      }
    }
  }).start();
}catch(BadLocationException ble) {
  Toolkit.getDefaultToolkit().beep();
}
</code></pre>

### 解説
`java.swing.Timer`でイベントを発生させ、目的位置と現在位置の差の半分だけ`ViewRect`のスクロールを繰り返すことで、アニメーションを行っています。

### 参考リンク
- [JTextAreaの任意の行に移動](http://terai.xrea.jp/Swing/GotoLine.html)

<!-- dummy comment line for breaking list -->

### コメント