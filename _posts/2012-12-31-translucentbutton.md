---
layout: post
title: JButtonを半透明にする
category: swing
folder: TranslucentButton
tags: [JButton, Translucent, GradientPaint, Icon, Html, OverlayLayout, JLabel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-12-31

## JButtonを半透明にする
半透明な`JButton`を作成します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/-W5o-8ilpY6k/UOCzLo2oOeI/AAAAAAAABZ0/m1_AjYpKqiY/s800/TranslucentButton.png)

### サンプルコード
<pre class="prettyprint"><code>class TranslucentButton extends JButton{
  private static final Color TL = new Color(1f,1f,1f,.2f);
  private static final Color BR = new Color(0f,0f,0f,.4f);
  private static final Color ST = new Color(1f,1f,1f,.2f);
  private static final Color SB = new Color(1f,1f,1f,.1f);
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
    Graphics2D g2 = (Graphics2D)g.create();
    g2.setRenderingHint(
      RenderingHints.KEY_ANTIALIASING,
      RenderingHints.VALUE_ANTIALIAS_ON);
    Shape area = new RoundRectangle2D.Float(x, y, w-1, h-1, r, r);
    ssc = TL;
    bgc = BR;
    ButtonModel m = getModel();
    if(m.isPressed()) {
      ssc = SB;
      bgc = ST;
    }else if(m.isRollover()) {
      ssc = ST;
      bgc = SB;
    }
    g2.setPaint(new GradientPaint(x, y, ssc, x, y+h, bgc, true));
    g2.fill(area);
    g2.setPaint(BR);
    g2.draw(area);
    g2.dispose();
    super.paintComponent(g);
  }
}
</code></pre>

### 解説
- 透明な`JButton`、全体を半透明な`Icon`、タイトルの`Icon`と文字列は`align='middle'`などを指定して配置
    - 参考: [JRadioButtonを使ってToggleButtonBarを作成](http://terai.xrea.jp/Swing/ToggleButtonBar.html)
    - `setOpaque(false);`, `setContentAreaFilled(false);`などで、`JButton`自体は透明化
    - タイトル`Icon`と文字列の`align`が、`top`、`middle`、`bottom`のどれにしてもきれいに揃わない
    - サイズが固定
    - `MetalLookAndFeel`に変更しても、余計なフチ？が表示されない
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
      setBorder(BorderFactory.createEmptyBorder());
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
label.setAlignmentX(.5f);
b = makeButton("");
b.setAlignmentX(.5f);
JPanel p = new JPanel();
p.setLayout(new OverlayLayout(p));
p.setOpaque(false);
p.add(label);
p.add(b);
add(p);
</code></pre>

- 半透明な`JButton`
    - `setOpaque(false);`, `setContentAreaFilled(false);`などを設定して`JButton`は透明にし、`JButton#paintComponent(...)`をオーバーライドして半透明の影などを描画
    - ~~`MetalLookAndFeel`で、余計なフチ？が表示される~~
    - `JButton#setBorderPainted(false);`で、フチを非表示にできる

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JRadioButtonを使ってToggleButtonBarを作成](http://terai.xrea.jp/Swing/ToggleButtonBar.html)
- ["ecqlipse 2" PNG by ~chrfb on deviantART](http://chrfb.deviantart.com/art/quot-ecqlipse-2-quot-PNG-59941546)

<!-- dummy comment line for breaking list -->

### コメント
