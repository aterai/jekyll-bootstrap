---
layout: post
category: swing
folder: AutoRepeatTimer
title: JButtonがマウスで押されている間、アクションを繰り返すTimerを設定する
tags: [JButton, ActionListener, MouseListener, Timer]
author: aterai
pubdate: 2015-06-08T00:00:32+09:00
description: JButtonがマウスで押されている間は指定したアクションを繰り返し実行するTimerを設定します。
comments: true
---
## 概要
`JButton`がマウスで押されている間は指定したアクションを繰り返し実行する`Timer`を設定します。

{% download https://lh3.googleusercontent.com/-zp2-TOEE4JE/VXRXk25rFUI/AAAAAAAAN6I/_Kn4GsC9a1g/s800/AutoRepeatTimer.png %}

## サンプルコード
<pre class="prettyprint"><code>class AutoRepeatHandler extends MouseAdapter implements ActionListener {
  private final Timer autoRepeatTimer;
  private final BigInteger extent;
  private final JLabel view;
  private JButton arrowButton;

  public AutoRepeatHandler(int extent, JLabel view) {
    super();
    this.extent = BigInteger.valueOf(extent);
    this.view = view;
    autoRepeatTimer = new Timer(60, this);
    autoRepeatTimer.setInitialDelay(300);
  }
  @Override public void actionPerformed(ActionEvent e) {
    Object o = e.getSource();
    if (o instanceof Timer) {
      if (Objects.nonNull(arrowButton)
          &amp;&amp; !arrowButton.getModel().isPressed()
          &amp;&amp; autoRepeatTimer.isRunning()) {
        autoRepeatTimer.stop();
        arrowButton = null;
      }
    } else if (o instanceof JButton) {
      arrowButton = (JButton) e.getSource();
    }
    BigInteger i = new BigInteger(view.getText());
    view.setText(i.add(extent).toString());
  }
  @Override public void mousePressed(MouseEvent e) {
    if (SwingUtilities.isLeftMouseButton(e)
        &amp;&amp; e.getComponent().isEnabled()) {
      autoRepeatTimer.start();
    }
  }
  @Override public void mouseReleased(MouseEvent e) {
    autoRepeatTimer.stop();
    arrowButton = null;
  }
  @Override public void mouseExited(MouseEvent e) {
    if (autoRepeatTimer.isRunning()) {
      autoRepeatTimer.stop();
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JButton`にクリックで指定した`JLabel`の数値を増減するための`ActionListener`と、自動リピートを行う`Timer`を起動するための`MouseListener`を設定しています。

- `JSpinner`で使用されている`javax.swing.plaf.basic.BasicSpinnerUI`内の`ArrowButtonHandler`と`Timer`のリピート間隔(`60ms`)や初回起動までの時間(`300ms`)は同じ値を設定

<!-- dummy comment line for breaking list -->

## コメント