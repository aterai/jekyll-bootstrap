---
layout: post
category: swing
folder: TranslucentToolBar
title: JToolBarの半透明化とアニメーション
tags: [JToolBar, Translucent, JButton]
author: aterai
pubdate: 2011-09-19T17:00:43+09:00
description: コンポーネントにマウスカーソルがある場合だけ表示される半透明のJToolBarを追加します。
image: https://lh5.googleusercontent.com/-36mkZfbor58/Tnb1d-2vaPI/AAAAAAAABCM/Hoor7aG7K-g/s800/TranslucentToolBar.png
comments: true
---
## 概要
コンポーネントにマウスカーソルがある場合だけ表示される半透明の`JToolBar`を追加します。

{% download https://lh5.googleusercontent.com/-36mkZfbor58/Tnb1d-2vaPI/AAAAAAAABCM/Hoor7aG7K-g/s800/TranslucentToolBar.png %}

## サンプルコード
<pre class="prettyprint"><code>class ImageCaptionLabel extends JLabel implements HierarchyListener {
  private float alpha = 0f;
  private javax.swing.Timer animator;
  private int yy = 0;
  private JToolBar toolBox = new JToolBar() {
    @Override protected void paintComponent(Graphics g) {
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setPaint(getBackground());
      g2.fillRect(0, 0, getWidth(), getHeight());
      g2.dispose();
      super.paintComponent(g);
    }
  };
  public ImageCaptionLabel(String caption, Icon image) {
    setIcon(image);
    toolBox.setFloatable(false);
    toolBox.setOpaque(false);
    toolBox.setBackground(new Color(0x0, true));
    toolBox.setForeground(Color.WHITE);
    toolBox.setBorder(BorderFactory.createEmptyBorder(2, 4, 4, 4));

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
    // ...
</code></pre>

## 解説
上記のサンプルでは、以下のリンクの方法を合わせて使用し、画像アイコンを表示した`JLabel`に半透明にした`JToolBar`を追加しています。

- `JToolBar`本体の透明化は、[JMenuBarの背景に画像を表示する](https://ateraimemo.com/Swing/MenuBarBackground.html)
- `JToolBar`内部に配置する`JButton`の透明化は、[JButtonの描画](https://ateraimemo.com/Swing/ButtonPainted.html)
- `JToolBar`の表示・非表示アニメーションは、[JTextAreaをキャプションとして画像上にスライドイン](https://ateraimemo.com/Swing/EaseInOut.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JMenuBarの背景に画像を表示する](https://ateraimemo.com/Swing/MenuBarBackground.html)
- [JButtonの描画](https://ateraimemo.com/Swing/ButtonPainted.html)
- [JTextAreaをキャプションとして画像上にスライドイン](https://ateraimemo.com/Swing/EaseInOut.html)
- ["ecqlipse 2" PNG by ~chrfb on deviantART](http://chrfb.deviantart.com/art/quot-ecqlipse-2-quot-PNG-59941546)
    - アイコンを借用

<!-- dummy comment line for breaking list -->

## コメント
