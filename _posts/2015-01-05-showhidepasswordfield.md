---
layout: post
category: swing
folder: ShowHidePasswordField
title: JPasswordFieldでパスワードを可視化する
tags: [JPasswordField, JCheckBox, JToggleButton, OverlayLayout, CardLayout]
author: aterai
pubdate: 2015-01-05T00:29:05+09:00
description: JPasswordFieldに入力したパスワードの表示・非表示を切り替えるためのボタンを作成し、これを入力欄などに配置します。
image: https://lh4.googleusercontent.com/-zXk3TZfF_v4/VPXFdo3UBzI/AAAAAAAANzU/VfiEUdm-aUI/s800/ShowHidePasswordField.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2015/01/showhide-passwordfield-using-cardlayout.html
    lang: en
comments: true
---
## 概要
`JPasswordField`に入力したパスワードの表示・非表示を切り替えるためのボタンを作成し、これを入力欄などに配置します。

{% download https://lh4.googleusercontent.com/-zXk3TZfF_v4/VPXFdo3UBzI/AAAAAAAANzU/VfiEUdm-aUI/s800/ShowHidePasswordField.png %}

## サンプルコード
<pre class="prettyprint"><code>JPasswordField pf = new JPasswordField(24);
pf.setText("abcdefghijklmn");
pf.setAlignmentX(Component.RIGHT_ALIGNMENT);
AbstractDocument doc = (AbstractDocument) pf.getDocument();
doc.setDocumentFilter(new ASCIIOnlyDocumentFilter());

AbstractButton b = new JToggleButton(new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    AbstractButton c = (AbstractButton) e.getSource();
    pf.setEchoChar(c.isSelected()
      ? '\u0000'
      : (Character) UIManager.get("PasswordField.echoChar"));
  }
});
b.setFocusable(false);
b.setOpaque(false);
b.setContentAreaFilled(false);
b.setBorder(BorderFactory.createEmptyBorder(0, 0, 0, 4));
b.setAlignmentX(Component.RIGHT_ALIGNMENT);
b.setAlignmentY(Component.CENTER_ALIGNMENT);
b.setIcon(new ColorIcon(Color.GREEN));
b.setRolloverIcon(new ColorIcon(Color.BLUE));
b.setSelectedIcon(new ColorIcon(Color.RED));
b.setRolloverSelectedIcon(new ColorIcon(Color.ORANGE));

JPanel panel = new JPanel() {
  @Override public boolean isOptimizedDrawingEnabled() {
    return false;
  }
};
panel.setLayout(new OverlayLayout(panel));
panel.add(b);
panel.add(pf);
</code></pre>

## 解説
上記のサンプルでは、`JPasswordField#setEchoChar(...)`メソッドの値に`\u0000`(`0`)を設定して入力したパスワードを可視状態に切り替えるためのボタンを追加しています。

- `BorderLayout + JCheckBox`:
    - `BorderLayout`で、`JPasswordField`の下にパスワード表示非表示切り替え用の`JCheckBox`を配置
- `OverlayLayout + JToggleButton`:
    - `OverlayLayout`で、`JPasswordField`内の右端にパスワード表示非表示切り替え用の`JToggleButton`を配置
    - `JPasswordField`と`JToggleButton`を配置する`JPanel`に、`OverlayLayout`を設定し、`z`軸が入れ替わらないように、`JPanel#isOptimizedDrawingEnabled()`が常に`false`を返すようオーバーライド
- `CardLayout + JTextField(can copy) + ...`:
    - 同じ`Document`を使用する`JPasswordField`と`JTextField`を`CardLayout`を設定した`JPanel`を作成
    - `OverlayLayout`を設定した`JPanel`に、上記の`JPanel`と`JToggleButton`を配置し、`JPasswordField`などの内部右端にボタンが表示されるように設定
    - `JTextField`をそのまま使用するので、表示中の文字列を選択してコピー可能
        
        <pre class="prettyprint"><code>JPasswordField pf3 = new JPasswordField(24);
        pf3.setText("abcdefghijklmn");
        AbstractDocument doc = (AbstractDocument) pf3.getDocument();
        JTextField tf3 = new JTextField(24);
        tf3.setFont(FONT);
        tf3.enableInputMethods(false);
        tf3.setDocument(doc);
        
        final CardLayout cardLayout = new CardLayout();
        final JPanel p3 = new JPanel(cardLayout);
        p3.setAlignmentX(Component.RIGHT_ALIGNMENT);
        p3.add(pf3, PasswordField.HIDE.toString());
        p3.add(tf3, PasswordField.SHOW.toString());
        
        AbstractButton b3 = new JToggleButton(new AbstractAction() {
          @Override public void actionPerformed(ActionEvent e) {
            AbstractButton c = (AbstractButton) e.getSource();
            PasswordField s = c.isSelected() ? PasswordField.SHOW
                                             : PasswordField.HIDE;
            cardLayout.show(p3, s.toString());
          }
        });
</code></pre>
- `press and hold down the mouse button`:
    - `OverlayLayout`で、`JPasswordField`内の右端にパスワード表示非表示切り替え用の`JButton`を配置
    - この`JButton`に`MouseListener`を追加して、マウスでクリックしている間はパスワードを表示するように設定
        
        <pre class="prettyprint"><code>b4.addMouseListener(new MouseAdapter() {
          @Override public void mousePressed(MouseEvent e) {
            pf4.setEchoChar('\u0000');
          }
          @Override public void mouseReleased(MouseEvent e) {
            pf4.setEchoChar((Character) UIManager.get("PasswordField.echoChar"));
          }
        });
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
- `passwordField.setEchoChar((char) 0);`を使用するサンプルを追加
    - [JPasswordField#setEchoChar(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JPasswordField.html#setEchoChar-char-)に、「値`0`に設定すると、標準の`JTextField`の動作と同様に、テキストが入力したとおりに表示されます。」とあるように、`passwordField.setEchoChar((char) 0);`とすれば、パスワード文字列の表示が可能
    - `CardLayout`を使って`JTextField`を表示する方法は一旦削除したが、表示中のパスワードをコピー可能なので、残しておくことにした
- ボタンをクリックしている間だけパスワードを表示するサンプルを追加

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JPasswordField#setEchoChar(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JPasswordField.html#setEchoChar-char-)
- [JPasswordFieldのエコー文字を変更](https://ateraimemo.com/Swing/PasswordView.html)

<!-- dummy comment line for breaking list -->

## コメント
