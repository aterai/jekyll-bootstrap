---
layout: post
title: Timerの使用数を変更
category: swing
folder: TimerAction
tags: [Timer, Animation]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-04-14

## 概要
パネルのタイルアニメーションで使用する`java.swing.Timer`の数を変更して動作のテストを行います。

{% download https://lh6.googleusercontent.com/-Kc02XwN3fHA/U0qu1BcXNEI/AAAAAAAACDg/UDwGuPoJmjk/s800/TimerAction.png %}

## サンプルコード
<pre class="prettyprint"><code>//Timer: 1, ActionListener: 100
class Tile2 extends JComponent {
  private int red;
  public Tile2(final Random rnd, Timer timer) {
    super();
    timer.addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        red = rnd.nextInt(255);
        repaint();
      }
    });
  }
  @Override public Dimension getPreferredSize() {
    return new Dimension(10, 10);
  }
  @Override protected void paintComponent(Graphics g) {
    super.paintComponent(g);
    g.setColor(new Color(red, 255 - red, 0));
    g.fillRect(0, 0, getWidth(), getHeight());
  }
}
</code></pre>

## 解説
- `Timer: 100`
    - `10x10`個のアニメーション用タイル一つに、`Timer`を生成して使用(その為、`Timer`も`10x10`個存在する)
    - `JDK 1.7.0_40`以降で低速
    - `JDK 1.8.0`は、`JDK 1.7.0_25`と同等？
- `Timer: 1, ActionListener: 100`
    - `Timer`は`1`個、`Timer#addActionListener(...)`で、`100`個の`ActionListener`を追加して使用
- `Timer: 1, ActionListener: 1`
    - `1`個の`Timer`を使用し、`for`ループで`10x10`のラベルの色を変更してアニメーションを実行

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - javax.swing.Timer slowdown in Java7u40 - Stack Overflow](http://stackoverflow.com/questions/18933986/javax-swing-timer-slowdown-in-java7u40)
    - `JDK 1.7.0_25`までは、どれも同じような速度でアニメーションするが、`JDK 1.7.0_40`以降は`Timer`の数を減らさないと遅くなる？
    - [Bug ID: JDK-7167780 Hang javasoft.sqe.tests.api.javax.swing.Timer.Ctor2Tests](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=7167780)の修正が影響している？

<!-- dummy comment line for breaking list -->

## コメント
