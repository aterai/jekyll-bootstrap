---
layout: post
category: swing
folder: TransparentFrame
title: JInternalFrameを半透明にする
tags: [JInternalFrame, JDesktopPane, ContentPane, Transparent, Translucent]
author: aterai
pubdate: 2007-04-30T21:08:08+09:00
description: JInternalFrameのフレーム内を半透明にします。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTV8kztxuI/AAAAAAAAAoc/oXSU5-bQorE/s800/TransparentFrame.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2011/02/translucent-jinternalframe-nimbus.html
    lang: en
comments: true
---
## 概要
`JInternalFrame`のフレーム内を半透明にします。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTV8kztxuI/AAAAAAAAAoc/oXSU5-bQorE/s800/TransparentFrame.png %}

## サンプルコード
<pre class="prettyprint"><code>JPanel p1 = new JPanel();
p1.setOpaque(false);

JPanel p2 = new JPanel() {
  @Override protected void paintComponent(Graphics g) {
    // super.paintComponent(g);
    g.setColor(new Color(100, 50, 50, 100));
    g.fillRect(0, 0, getWidth(), getHeight());
  }
};

JPanel p3 = new JPanel() {
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D) g;
    // g2.setPaint(new Color(100, 120, 100, 100));
    g2.setPaint(texture);
    g2.fillRect(0, 0, getWidth(), getHeight());
  }
};

protected JInternalFrame createFrame(JPanel panel) {
  MyInternalFrame frame = new MyInternalFrame();
  if (panel != null) {
    frame.setContentPane(panel);
    // JButton button = new JButton("button");
    // button.setOpaque(false);
    panel.add(new JLabel("label"));
    panel.add(new JButton("button"));
  }
  desktop.add(frame);
  frame.setOpaque(false);
  frame.setVisible(true);
  // ...
</code></pre>

## 解説
上記のサンプルでは、各`JInternalFrame`の`ContentPane`を`JInternalFrame#setContentPane(Container)`メソッドを使用して半透明パネルに変更しています。

- `Frame#1` (`Transparent`)
    - `ContentPane`を`setOpaque(false)`して透明化

<!-- dummy comment line for breaking list -->

- `Frame#2` (`Translucent`)
    - `ContentPane`を半透明な色で塗りつぶし

<!-- dummy comment line for breaking list -->

- `Frame#3` (`Translucent`)
    - `ContentPane`を半透明な色を使ってチェック柄で塗りつぶし

<!-- dummy comment line for breaking list -->

## 参考リンク
- [デジタル出力工房　絵写楽](http://www.bekkoame.ne.jp/~bootan/free2.html)
- [SynthでJInternalFrameを半透明にする](https://ateraimemo.com/Swing/TranslucentFrame.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JRE6.0`だと、半透明にならずチェック模様が描画されるだけですね。仕様変わったのかな… --  2007-05-25 (金) 11:05:17
    - 御指摘ありがとうございます。`Windows XP`で、`Java 1.6.0_01`、`1.5.0_11`は、半透明になったのですが、`Ubuntu 7.04`で、`Java 1.6.0`では駄目みたいです。`Mac`は環境がないので試せてません。 -- *aterai* 2007-05-25 (金) 13:02:13
    - すこし調べてみたのですが、`Ubuntu`(`GNOME`) でも半透明にするには`JInternalFrame#setOpaque(false)`も必要みたいです。修正しておきます。 -- *aterai* 2007-05-25 (金) 13:07:50
    - 再度試してみたら、`JInternalFrame#setOpaque(false)`しても、`Ubuntu`(`GNOME`)+`JDK 1.6.0`+`GTKLookAndFeel`で半透明になってくれません。~~なにか`Ubuntu`の設定を弄ったから？~~ -- *aterai* 2007-10-10 (水) 18:49:22
- `NimbusLookAndFeel`でも透明にできないようです。どちらも`SynthLookAndFeel`がベースなので、それが原因？ -- *aterai* 2007-11-15 (木) 13:32:50
    - 追記: [SynthでJInternalFrameを半透明にする](https://ateraimemo.com/Swing/TranslucentFrame.html) -- *aterai* 2008-12-01 (月) 15:06:12

<!-- dummy comment line for breaking list -->
