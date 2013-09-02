---
layout: post
title: JPanelをアコーディオン風に展開
category: swing
folder: AccordionPanel
tags: [JPanel, BorderLayout]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-11-08

## JPanelをアコーディオン風に展開
`JPanel`の展開、折り畳みをアコーディオン風に行います。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTHVHwFBII/AAAAAAAAARA/QX4AmSbPoHs/s800/AccordionPanel.png)

### サンプルコード
<pre class="prettyprint"><code>abstract class ExpansionPanel extends JPanel{
  abstract public JPanel makePanel();
  private final String title;
  private final JLabel label;
  private final JPanel panel;

  public ExpansionPanel(String title) {
    super(new BorderLayout());
    this.title = title;
    label = new JLabel("↓ "+title) {
      @Override protected void paintComponent(Graphics g) {
        Graphics2D g2 = (Graphics2D)g;
        //Insets ins = getInsets();
        g2.setPaint(new GradientPaint(50, 0, Color.WHITE,
            getWidth(), getHeight(), new Color(200,200,255)));
        g2.fillRect(0, 0, getWidth(), getHeight());
        super.paintComponent(g);
      }
    };
    label.addMouseListener(new MouseAdapter() {
      @Override public void mousePressed(MouseEvent evt) {
        initPanel();
      }
    });
    label.setForeground(Color.BLUE);
    label.setBorder(BorderFactory.createEmptyBorder(2,5,2,2));
    add(label, BorderLayout.NORTH);

    panel = makePanel();
    panel.setVisible(false);
    panel.setOpaque(true);
    panel.setBackground(new Color(240, 240, 255));
    Border b1 = BorderFactory.createMatteBorder(0,2,2,2,Color.WHITE);
    Border b2 = BorderFactory.createEmptyBorder(10,10,10,10);
    Border b3 = BorderFactory.createCompoundBorder(b1, b2);
    panel.setBorder(b3);
    add(panel);
  }
  @Override public Dimension getPreferredSize() {
    Dimension d = label.getPreferredSize();
    if(panel.isVisible()) {
      d.height += panel.getPreferredSize().height;
    }
    return d;
  }
  @Override public Dimension getMaximumSize() {
    Dimension d = getPreferredSize();
    d.width = Short.MAX_VALUE;
    return d;
  }
  protected void initPanel() {
    panel.setVisible(!panel.isVisible());
    label.setText((panel.isVisible()?"↑ ":"↓ ")+title);
    revalidate();
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        panel.scrollRectToVisible(panel.getBounds());
      }
    });
  }
}
</code></pre>

### 解説
各パネルに配置されたタイトルラベルがクリックされた場合、`JPanel#setVisible(boolean)`メソッドを使って、パネルの表示・非表示を切り替えています。

また、パネルを非表示にするだけでは、その高さが変更されないので、以下のように、`JPanel#getPreferredSize()`もオーバーライドしています。

<pre class="prettyprint"><code>@Override public Dimension getPreferredSize() {
  Dimension d = label.getPreferredSize();
  if(panel.isVisible()) {
    d.height += panel.getPreferredSize().height;
  }
  return d;
}
</code></pre>

- - - -
[L2FProd.com - Common Components](http://common.l2fprod.com/) にある`JTaskPane`で、アニメーション付きのパネルの展開や折り畳みが可能です。ソースも公開されているので、`com.l2fprod.common.swing.JCollapsiblePane`あたりを参考にしてみてください。

### 参考リンク
- [JPanelの展開と折り畳み](http://terai.xrea.jp/Swing/ExpandablePanel.html)
- [BoxLayoutでリスト状に並べる](http://terai.xrea.jp/Swing/ComponentList.html)
- [JTreeのノードを検索する](http://terai.xrea.jp/Swing/SearchBox.html)
    - アニメーションさせる場合のサンプル

<!-- dummy comment line for breaking list -->

### コメント
- `SpringLayout`を`BoxLayout`に変更。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-05-15 (金) 22:33:23
- 不要なコードを削除。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-11-16 (火) 21:29:33
- 不要(になった？)なリスナクラスなどを削除。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-08-21 (火) 16:33:17

<!-- dummy comment line for breaking list -->

