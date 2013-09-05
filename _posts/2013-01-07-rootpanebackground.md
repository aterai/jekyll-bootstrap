---
layout: post
title: JRootPaneの背景として画像を表示
category: swing
folder: RootPaneBackground
tags: [JRootPane, BufferedImage, ContentPane, JDesktopPane, Translucent, Transparent]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-01-07

## JRootPaneの背景として画像を表示
`JRootPane`の背景として画像を表示しています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/-2HEcpl-4XqA/UOmSieyPnxI/AAAAAAAABaI/KBA4i6QGH3E/s800/RootPaneBackground.png)

### サンプルコード
<pre class="prettyprint"><code>JFrame frame = new JFrame("@title@") {
  @Override protected JRootPane createRootPane() {
    JRootPane rp = new JRootPane() {
      //private final TexturePaint texture = makeCheckerTexture();
      @Override protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2 = (Graphics2D)g.create();
        g2.setPaint(texture);
        g2.fillRect(0, 0, getWidth(), getHeight());
        g2.dispose();
      }
      @Override public void updateUI() {
        super.updateUI();
        BufferedImage bi = makeBufferedImage("test.jpg");
        setBorder(new CentredBackgroundBorder(bi));
        setOpaque(false);
      }
    };
    return rp;
  }
};
//frame.getRootPane().setBackground(Color.BLUE);
//frame.getLayeredPane().setBackground(Color.GREEN);
//frame.getContentPane().setBackground(Color.RED);
((JComponent)frame.getContentPane()).setOpaque(false);
frame.setJMenuBar(createMenubar());
frame.getContentPane().add(new MainPanel());
</code></pre>

### 解説
このサンプルでは、`JFrame#createRootPane()`メソッドをオーバーライドして、以下の方法で背景に画像を描画する`JRootPane`を作成しています。

- 中央の画像: [CentredBackgroundBorder](https://forums.oracle.com/forums/thread.jspa?threadID=1393763)を使用
- チェック柄: `JRootPane#paintComponent(...)`をオーバーライド

<!-- dummy comment line for breaking list -->

- - - -
- `JRootPane`の子コンポーネントの透明化、半透明化
    - `ContentPane`: `setOpaque(false);`で透明化
    - `JDesktopPane`:  `setOpaque(false);`で透明化
        - 参考: [JInternalFrameを半透明にする](http://terai.xrea.jp/Swing/TransparentFrame.html)
        - `NimbusLookAndFeel`には未対応
    - `JMenuBar`: `setOpaque(false);`で透明化し、`JMenuBar#paintComponent(...)`をオーバーライドして半透明化
    - `JMenu`, `JMenuItem`など: `setOpaque(false);`で透明化、`LookAndFeel`によって、`JMenu#setBackground(new Color(0,0,0,0));`、`UIManager.put("Menu.selectionBackground", new Color(0,0,100,100));`などを使用
        - 参考: [JMenuBarの背景に画像を表示する](http://terai.xrea.jp/Swing/MenuBarBackground.html)
    - `JPopupMenu`: [JMenuなどから開くPopupMenuを半透明化](http://terai.xrea.jp/Swing/TranslucentSubMenu.html)などで、半透明化

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing - How can I use TextArea with Background Picture ?](https://forums.oracle.com/forums/thread.jspa?threadID=1393763)
    - [JTextAreaの背景に画像を表示](http://terai.xrea.jp/Swing/CentredBackgroundBorder.html)

<!-- dummy comment line for breaking list -->

### コメント