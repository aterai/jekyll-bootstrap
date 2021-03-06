---
layout: post
category: swing
folder: TranslucentButton
title: JButtonを半透明にする
tags: [JButton, Translucent, GradientPaint, Icon, Html, OverlayLayout, JLabel]
author: aterai
pubdate: 2012-12-31T06:46:18+09:00
description: 背景が透明なJButtonに半透明なIconを設定するなどして、ボタンテキスト以外が半透明なJButtonを作成します。
image: https://lh3.googleusercontent.com/-W5o-8ilpY6k/UOCzLo2oOeI/AAAAAAAABZ0/m1_AjYpKqiY/s800/TranslucentButton.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2013/01/make-translucent-jbutton.html
    lang: en
comments: true
---
## 概要
背景が透明な`JButton`に半透明な`Icon`を設定するなどして、ボタンテキスト以外が半透明な`JButton`を作成します。

{% download https://lh3.googleusercontent.com/-W5o-8ilpY6k/UOCzLo2oOeI/AAAAAAAABZ0/m1_AjYpKqiY/s800/TranslucentButton.png %}

## サンプルコード
<pre class="prettyprint"><code>class TranslucentButton extends JButton {
  private static final Color TL = new Color(1f, 1f, 1f, .2f);
  private static final Color BR = new Color(0f, 0f, 0f, .4f);
  private static final Color ST = new Color(1f, 1f, 1f, .2f);
  private static final Color SB = new Color(1f, 1f, 1f, .1f);
  private Color ssc;
  private Color bgc;
  private int r = 8;
  public TranslucentButton(String text) {
    super(text);
  }
  public TranslucentButton(String text, Icon icon) {
    super(text, icon);
  }
  @Override public void updateUI() {
    super.updateUI();
    setContentAreaFilled(false);
    setFocusPainted(false);
    setOpaque(false);
    setForeground(Color.WHITE);
  }
  @Override protected void paintComponent(Graphics g) {
    int x = 0;
    int y = 0;
    int w = getWidth();
    int h = getHeight();
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setRenderingHint(
      RenderingHints.KEY_ANTIALIASING,
      RenderingHints.VALUE_ANTIALIAS_ON);
    Shape area = new RoundRectangle2D.Float(x, y, w - 1, h - 1, r, r);
    ssc = TL;
    bgc = BR;
    ButtonModel m = getModel();
    if (m.isPressed()) {
      ssc = SB;
      bgc = ST;
    } else if (m.isRollover()) {
      ssc = ST;
      bgc = SB;
    }
    g2.setPaint(new GradientPaint(x, y, ssc, x, y + h, bgc, true));
    g2.fill(area);
    g2.setPaint(BR);
    g2.draw(area);
    g2.dispose();
    super.paintComponent(g);
  }
}
</code></pre>

## 解説
- 透明な`JButton`、全体を半透明な`Icon`、タイトルの`Icon`と文字列は`align='middle'`などを指定して配置
    - 参考: [JRadioButtonを使ってToggleButtonBarを作成](https://ateraimemo.com/Swing/ToggleButtonBar.html)
    - `setOpaque(false);`、`setContentAreaFilled(false);`などで、`JButton`自体は透明化
    - タイトル`Icon`と文字列の`align`に、`top`、`middle`、`bottom`のどれを設定してもベースラインで揃わない
    - サイズが固定
    - `MetalLookAndFeel`に変更しても、余計な`Border`が表示されない
    - `Html`を使っているので`GTKLookAndFeel`で、`Pressed`時の文字色変更に対応していない

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private static String makeTitleWithIcon(URL u, String t, String a) {
  return String.format(
    "&lt;html&gt;&lt;p align='%s'&gt;&lt;img src='%s' align='%s' /&gt;&amp;nbsp;%s", a, u, a, t);
}
private static AbstractButton makeButton(String title) {
  return new JButton(title) {
    @Override public void updateUI() {
      super.updateUI();
      setVerticalAlignment(SwingConstants.CENTER);
      setVerticalTextPosition(SwingConstants.CENTER);
      setHorizontalAlignment(SwingConstants.CENTER);
      setHorizontalTextPosition(SwingConstants.CENTER);
      setMargin(new Insets(2, 8, 2, 8));
      setBorder(BorderFactory.createEmptyBorder(2, 8, 2, 8));
      //setBorderPainted(false);
      setContentAreaFilled(false);
      setFocusPainted(false);
      setOpaque(false);
      setForeground(Color.WHITE);
      setIcon(new TranslucentButtonIcon());
    }
  };
}
</code></pre>

- 透明な`JButton`、全体を半透明な`Icon`、タイトルの`Icon`と文字列は`JLabel`を`OverlayLayout`で配置
    - `Html`の`align`ではなく、`Baseline`の揃った`JLabel`を半透明な`JButton`に重ねて表示
    - `JButton`のテキストは空なので、`GTKLookAndFeel`で、`Pressed`時の文字色変更に対応していない

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JLabel label = new JLabel("JLabel", icon, SwingConstants.CENTER);
label.setForeground(Color.WHITE);
label.setAlignmentX(Component.CENTER_ALIGNMENT);
b = makeButton("");
b.setAlignmentX(Component.CENTER_ALIGNMENT);
JPanel p = new JPanel();
p.setLayout(new OverlayLayout(p));
p.setOpaque(false);
p.add(label);
p.add(b);
add(p);
</code></pre>

- 透明な`JButton`、全体を半透明な`Icon`
    - `setOpaque(false);`, `setContentAreaFilled(false);`などを設定して`JButton`は透明にし、`JButton#paintComponent(...)`をオーバーライドして半透明の影などを描画
    - ~~`MetalLookAndFeel`で、余計なフチ？が表示される~~
    - `JButton#setBorderPainted(false);`で、`Border`を非表示にできる
    - `setBorder(BorderFactory.createEmptyBorder(2, 8, 2, 8));`で設定した余白は、`Icon`自体のサイズには含めないが、`Icon`の描画は使用する
    - `JButton#setMargin(new Insets(2, 8, 2, 8));`が有効かどうかは、環境または`LookAndFeel`に依存する？

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class TranslucentButtonIcon implements Icon {
  private static final Color TL = new Color(1f, 1f, 1f, .2f);
  private static final Color BR = new Color(0f, 0f, 0f, .4f);
  private static final Color ST = new Color(1f, 1f, 1f, .2f);
  private static final Color SB = new Color(1f, 1f, 1f, .1f);
  private static final int R = 8;
  private int width;
  private int height;
  public TranslucentButtonIcon(JComponent c) {
    Insets i = c.getInsets();
    Dimension d = c.getPreferredSize();
    width  = d.width - i.left - i.right;
    height = d.height - i.top - i.bottom;
  }
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    if (c instanceof AbstractButton) {
      AbstractButton b = (AbstractButton) c;
      // XXX: Insets i = b.getMargin();
      Insets i = b.getInsets();
      int w = c.getWidth();
      int h = c.getHeight();
      width  = w - i.left - i.right;
      height = h - i.top - i.bottom;
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                          RenderingHints.VALUE_ANTIALIAS_ON);
      Shape area = new RoundRectangle2D.Float(
          x - i.left, y - i.top, w - 1, h - 1, R, R);
      Color ssc = TL;
      Color bgc = BR;
      ButtonModel m = b.getModel();
      if (m.isPressed()) {
        ssc = SB;
        bgc = ST;
      } else if (m.isRollover()) {
        ssc = ST;
        bgc = SB;
      }
      g2.setPaint(new GradientPaint(0, 0, ssc, 0, h, bgc, true));
      g2.fill(area);
      g2.setPaint(BR);
      g2.draw(area);
      g2.dispose();
    }
  }
  @Override public int getIconWidth()  {
    return Math.max(width, 100);
  }
  @Override public int getIconHeight() {
    return Math.max(height, 20);
  }
}
</code></pre>

## 参考リンク
- [JRadioButtonを使ってToggleButtonBarを作成](https://ateraimemo.com/Swing/ToggleButtonBar.html)
- ["ecqlipse 2" PNG by ~chrfb on deviantART](http://chrfb.deviantart.com/art/quot-ecqlipse-2-quot-PNG-59941546)

<!-- dummy comment line for breaking list -->

## コメント
