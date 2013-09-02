---
layout: post
title: AWTEventを取得して入力イベントを監視
category: swing
folder: DispatchEvent
tags: [AWTEvent, Toolkit, AWTEventListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-02-11

## AWTEventを取得して入力イベントを監視
`AWTEvent`を取得して、マウスやキーボードの入力イベントを監視します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTLPUOE2MI/AAAAAAAAAXQ/5qrFGk7E5GM/s800/DispatchEvent.png)

### サンプルコード
<pre class="prettyprint"><code>private static int DELAY = 10*1000; //10s
private final javax.swing.Timer timer = new javax.swing.Timer(DELAY, new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    setTestConnected(false);
    Toolkit.getDefaultToolkit().removeAWTEventListener(awtEvent);
    timer.stop();
  }
});
private final AWTEventListener awtEvent = new AWTEventListener() {
  @Override public void eventDispatched(AWTEvent e) {
    if(timer!=null &amp;&amp; timer.isRunning()) {
      //System.out.println("timer.restart()");
      timer.restart();
    }
  }
};
JButton button = new JButton(new AbstractAction("Connect") {
  @Override public void actionPerformed(ActionEvent e) {
    setTestConnected(true);
    Toolkit.getDefaultToolkit().addAWTEventListener(awtEvent,
        AWTEvent.KEY_EVENT_MASK + AWTEvent.MOUSE_EVENT_MASK);
    timer.setRepeats(false);
    timer.start();
  }
});
</code></pre>

### 解説
上記のサンプルでは、一定時間(`10`秒)、マウスやキーボードからの入力が無い場合、接続(ダミー)を切るようになっています。


- - - -
[Application Inactivity « Java Tips Weblog](http://tips4java.wordpress.com/2008/10/24/application-inactivity/)を参考にして、`Toolkit.getDefaultToolkit().getSystemEventQueue().push(eventQueue)`は使用せず、以下のように`Toolkit.getDefaultToolkit().addAWTEventListener(AWTEventListener)`を使う方法に変更しました。

- `timer`を`timer.setRepeats(false);`でスタート(一回で終了する)
- `Toolkit.getDefaultToolkit().addAWTEventListener`で、`AWTEventListener`を設定
- `AWTEvent`が発生した時に`timer.restart();`でタイマーをリセット
- 時間がきたら`Toolkit.getDefaultToolkit().removeAWTEventListener`で`AWTEvent`を取り除く

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Application Inactivity « Java Tips Weblog](http://tips4java.wordpress.com/2008/10/24/application-inactivity/)

<!-- dummy comment line for breaking list -->

### コメント
