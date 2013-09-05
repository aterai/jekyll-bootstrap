---
layout: post
title: JToolBarの半透明化とアニメーション
category: swing
folder: TranslucentToolBar
tags: [JToolBar, Translucent, JButton]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-09-19

## JToolBarの半透明化とアニメーション
コンポーネントにマウスカーソルがある場合だけ表示される半透明の`JToolBar`を追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/-36mkZfbor58/Tnb1d-2vaPI/AAAAAAAABCM/Hoor7aG7K-g/s800/TranslucentToolBar.png)

### サンプルコード
<pre class="prettyprint"><code>class ImageCaptionLabel extends JLabel implements HierarchyListener {
  private float alpha = 0.0f;
  private javax.swing.Timer animator;
  private int yy = 0;
  private JToolBar toolBox = new JToolBar() {
    @Override protected void paintComponent(Graphics g) {
      Graphics2D g2 = (Graphics2D)g;
      g2.setPaint(getBackground());
      g2.fillRect(0, 0, getWidth(), getHeight());
      super.paintComponent(g);
    }
  };
  public ImageCaptionLabel(String caption, Icon image) {
    setIcon(image);
    toolBox.setFloatable(false);
    toolBox.setOpaque(false);
    toolBox.setBackground(new Color(0,0,0,0));
    toolBox.setForeground(Color.WHITE);
    toolBox.setBorder(BorderFactory.createEmptyBorder(2,4,4,4));

    //toolBox.setLayout(new BoxLayout(toolBox, BoxLayout.X_AXIS));
    toolBox.add(Box.createGlue());
    toolBox.add(makeToolButton("ATTACHMENT_16x16-32.png"));
    toolBox.add(Box.createHorizontalStrut(2));
    toolBox.add(makeToolButton("RECYCLE BIN - EMPTY_16x16-32.png"));

    MouseAdapter ma = new MouseAdapter() {
      @Override public void mouseEntered(MouseEvent e) {
        dispatchMouseEvent(e);
      }
      @Override public void mouseExited(MouseEvent e) {
        dispatchMouseEvent(e);
      }
      private void dispatchMouseEvent(MouseEvent e) {
        Component src = e.getComponent();
        Component tgt = ImageCaptionLabel.this;
        tgt.dispatchEvent(SwingUtilities.convertMouseEvent(src, e, tgt));
      }
    };
    toolBox.addMouseListener(ma);
//......
</code></pre>

### 解説
上記のサンプルでは、画像を表示した`JLabel`に半透明にした`JToolBar`を追加しています。

- 参考
    - `JToolBar`などの透明化は、[JMenuBarの背景に画像を表示する](http://terai.xrea.jp/Swing/MenuBarBackground.html)
    - 表示アニメーションは、[JTextAreaをキャプションとして画像上にスライドイン](http://terai.xrea.jp/Swing/EaseInOut.html)
    - `JToolBar`内部の`JButton`は、[JButtonの描画](http://terai.xrea.jp/Swing/ButtonPainted.html)

<!-- dummy comment line for breaking list -->

### 参考リンク
- ["ecqlipse 2" PNG by ~chrfb on deviantART](http://chrfb.deviantart.com/art/quot-ecqlipse-2-quot-PNG-59941546)
    - アイコンを借りています。

<!-- dummy comment line for breaking list -->

### コメント