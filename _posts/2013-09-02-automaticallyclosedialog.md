---
layout: post
title: JOptionPaneを自動的に閉じる
category: swing
folder: AutomaticallyCloseDialog
tags: [JOptionPane, Timer, HierarchyListener, JLabel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-09-02

## JOptionPaneを自動的に閉じる
`JOptionPane`にカウントダウンと自動クローズを行うための`JLabel`を追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-NvrpIdRXy8M/UiMOJmS8OMI/AAAAAAAABzg/6QK49B0s-NE/s800/AutomaticallyCloseDialog.png)

### サンプルコード
<pre class="prettyprint"><code>label.addHierarchyListener(new HierarchyListener() {
  private Timer timer = null;
  private AtomicInteger atomicDown = new AtomicInteger(SECONDS);
  @Override public void hierarchyChanged(HierarchyEvent e) {
    final JLabel l = (JLabel)e.getComponent();
    if((e.getChangeFlags() &amp; HierarchyEvent.SHOWING_CHANGED)!=0) {
      if(l.isShowing()) {
        textArea.append("isShowing=ture\n");
        atomicDown.set(SECONDS);
        l.setText(String.format("Closing in %d seconds", SECONDS));
        timer = new Timer(1000, new ActionListener() {
          //private int countdown = SECONDS;
          @Override public void actionPerformed(ActionEvent e) {
            //int i = --countdown;
            int i = atomicDown.decrementAndGet();
            l.setText(String.format("Closing in %d seconds", i));
            if(i&lt;=0) {
              Window w = SwingUtilities.getWindowAncestor(l);
              if(w!=null &amp;&amp; timer!=null &amp;&amp; timer.isRunning()) {
                textArea.append("Timer: timer.stop()\n");
                timer.stop();
                textArea.append("window.dispose()\n");
                w.dispose();
              }
            }
          }
        });
        timer.start();
      }else{
        textArea.append("isShowing=false\n");
        if(timer!=null &amp;&amp; timer.isRunning()) {
          textArea.append("timer.stop()\n");
          timer.stop();
          timer = null;
        }
      }
    }
  }
});
</code></pre>

### 解説
- `java.awt.event.HierarchyListener`
    - `HierarchyListener`を使って、`JLabel`の表示状態の変化を監視
        - [JOptionPaneのデフォルトフォーカス](http://terai.xrea.jp/Swing/OptionPaneDefaultFocus.html)
- `javax.swing.Timer`
    - `JLabel`の表示状態の変化し、`JLabel#isShowing()`が`true`となって親の`JOptionPane`が表示されたら、`Timer#start()`でカウントダウンを開始
        - [JComponentの表示状態](http://terai.xrea.jp/Swing/ShowingDisplayableVisible.html)
    - 指定した時間が経過したら、`Window#dispose()`を使って、親の`JOptionPane`を自動的に閉じる
        - `Window#dispose()`を使うので、`JOptionPane.showConfirmDialog(...)`の戻り値は、`JOptionPane.CLOSED_OPTION`になる

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JComponentの表示状態](http://terai.xrea.jp/Swing/ShowingDisplayableVisible.html)
- [JOptionPaneのデフォルトフォーカス](http://terai.xrea.jp/Swing/OptionPaneDefaultFocus.html)
- [swing - Java: How to continuously update JLabel which uses atomicInteger to countdown after ActionListener - Stack Overflow](http://stackoverflow.com/questions/10021969/java-how-to-continuously-update-jlabel-which-uses-atomicinteger-to-countdown-af)

<!-- dummy comment line for breaking list -->

### コメント
