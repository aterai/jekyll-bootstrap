---
layout: post
category: swing
folder: DispatchEvent
title: AWTEventを取得して入力イベントを監視
tags: [AWTEvent, Toolkit, AWTEventListener]
author: aterai
pubdate: 2008-02-11T21:32:38+09:00
description: AWTEventを取得して、マウスやキーボードの入力イベントを監視します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTLPUOE2MI/AAAAAAAAAXQ/5qrFGk7E5GM/s800/DispatchEvent.png
comments: true
---
## 概要
`AWTEvent`を取得して、マウスやキーボードの入力イベントを監視します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTLPUOE2MI/AAAAAAAAAXQ/5qrFGk7E5GM/s800/DispatchEvent.png %}

## サンプルコード
<pre class="prettyprint"><code>private static int DELAY = 10 * 1000; //10s
private final Timer timer = new Timer(DELAY, new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    setTestConnected(false);
    Toolkit.getDefaultToolkit().removeAWTEventListener(awtEvent);
    timer.stop();
  }
});
private final AWTEventListener awtEvent = new AWTEventListener() {
  @Override public void eventDispatched(AWTEvent e) {
    if (timer != null &amp;&amp; timer.isRunning()) {
      // System.out.println("timer.restart()");
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

## 解説
上記のサンプルでは、一定時間(`10`秒)マウスやキーボードからの入力が無い場合は接続(ダミー)を終了するよう`AWTEventListener`を`Toolkit`に設定しています。

- - - -
- [Application Inactivity « Java Tips Weblog](https://tips4java.wordpress.com/2008/10/24/application-inactivity/)を参考にして、`Toolkit.getDefaultToolkit().getSystemEventQueue().push(eventQueue)`は使用せず、以下のように`Toolkit.getDefaultToolkit().addAWTEventListener(AWTEventListener)`を使う方法に変更
    - `timer`を`timer.setRepeats(false);`でスタート(一回で終了する)
    - `Toolkit.getDefaultToolkit().addAWTEventListener`で、`AWTEventListener`を設定
    - `AWTEvent`が発生した時に`timer.restart();`でタイマーをリセット
    - 時間がきたら`Toolkit.getDefaultToolkit().removeAWTEventListener`で`AWTEvent`を取り除く
    - `JDK 1.7.0`以上の場合、[LayerUI (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/LayerUI.html)で同様の処理が可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Application Inactivity « Java Tips Weblog](https://tips4java.wordpress.com/2008/10/24/application-inactivity/)

<!-- dummy comment line for breaking list -->

## コメント
- `java.security.AccessControlException: access denied ("java.awt.AWTPermission" "listenToAllAWTEvents")`が発生するので、`Web Start`起動のリンクを削除。 -- *aterai* 2014-01-14 (火) 13:57:01

<!-- dummy comment line for breaking list -->
