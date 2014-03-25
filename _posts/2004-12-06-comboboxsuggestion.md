---
layout: post
title: JComboBoxで候補一覧を表示
category: swing
folder: ComboBoxSuggestion
tags: [JComboBox, KeyListener, JPopupMenu]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-12-06

## JComboBoxで候補一覧を表示
`JComboBox`に入力候補の一覧表示機能(補完機能、コードアシスト、コンテンツアシスト)を追加します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJwW_1EoI/AAAAAAAAAU4/ENqthfUJCsc/s800/ComboBoxSuggestion.png)

### サンプルコード
<pre class="prettyprint"><code>String[] array = {
    "aaaa", "aaaabbb", "aaaabbbcc", "aaaabbbccddd",
    "abcde", "abefg", "bbb1", "bbb12"};
JComboBox combo = new JComboBox(array);
combo.setEditable(true);
combo.setSelectedIndex(-1);
JTextField field = (JTextField)combo.getEditor().getEditorComponent();
field.setText("");
field.addKeyListener(new ComboKeyHandler(combo));
</code></pre>

<pre class="prettyprint"><code>class ComboKeyHandler extends KeyAdapter{
  private final JComboBox comboBox;
  private final Vector&lt;String&gt; list = new Vector&lt;&gt;();
  public ComboKeyHandler(JComboBox combo) {
    this.comboBox = combo;
    for(int i=0;i&lt;comboBox.getModel().getSize();i++) {
      list.addElement((String)comboBox.getItemAt(i));
    }
  }
  private boolean shouldHide = false;
  @Override public void keyTyped(final KeyEvent e) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        String text = ((JTextField)e.getSource()).getText();
        if(text.length()==0) {
          setSuggestionModel(comboBox, new DefaultComboBoxModel(list), "");
          comboBox.hidePopup();
        }else{
          ComboBoxModel m = getSuggestedModel(list, text);
          if(m.getSize()==0 || shouldHide) {
            comboBox.hidePopup();
          }else{
            setSuggestionModel(comboBox, m, text);
            comboBox.showPopup();
          }
        }
      }
    });
  }
  @Override public void keyPressed(KeyEvent e) {
    JTextField textField = (JTextField)e.getSource();
    String text = textField.getText();
    shouldHide = false;
    switch(e.getKeyCode()) {
      case KeyEvent.VK_RIGHT:
        for(String s: list) {
          if(s.startsWith(text)) {
            textField.setText(s);
            return;
          }
        }
        break;
      case KeyEvent.VK_ENTER:
        if(!list.contains(text)) {
          list.addElement(text);
          Collections.sort(list);
          setSuggestionModel(comboBox, getSuggestedModel(list, text), text);
        }
        shouldHide = true;
        break;
      case KeyEvent.VK_ESCAPE:
        shouldHide = true;
        break;
    }
  }
  private static void setSuggestionModel(JComboBox comboBox, ComboBoxModel mdl, String str) {
    comboBox.setModel(mdl);
    comboBox.setSelectedIndex(-1);
    ((JTextField)comboBox.getEditor().getEditorComponent()).setText(str);
  }
  private static ComboBoxModel getSuggestedModel(Vector&lt;String&gt; list, String text) {
    DefaultComboBoxModel m = new DefaultComboBoxModel();
    for(String s: list) {
      if(s.startsWith(text)) m.addElement(s);
    }
    return m;
  }
}
</code></pre>

### 解説
上記のサンプルでは、次のキー操作に対応しています。

- <kbd>Up</kbd><kbd>Down</kbd>キー
    - ポップアップ表示
- <kbd>Esc</kbd>キー
    - ポップアップ非表示
- <kbd>Right</kbd>キー
    - 補完
- <kbd>Enter</kbd>キー
    - 選択、または追加
- 文字入力
    - 候補をポップアップ

<!-- dummy comment line for breaking list -->

`JComboBox#showPopup()`と`JComboBox#hidePopup()`(それぞれ、`JComboBox#setPopupVisible`メソッドをラップしているだけ)を使って、候補のポップアップメニュー表示を制御します。

`JComboBox#setSelectedIndex(-1)`で、項目の選択をクリアしないと動作がおかしくなる場合があります。

- - - -
`JComboBox`ではなく、`SwingSet3`の[JHistoryTextField.java](http://java.net/projects/swingset3/sources/svn/content/trunk/SwingSet3/src/com/sun/swingset3/demos/textfield/JHistoryTextField.java) のように、`JTextField`+`JPopupMenu`を使用することもできますが、画面の下側で候補数が変更された場合の`JPopupMenu`の位置更新(気にしなければ問題無し)が面倒です。`JTextField`風に見せかけたいだけなら、以下のような`ArrowButton`を非表示にする方法もあります。

<pre class="prettyprint"><code>//UIManager.put("ComboBox.squareButton", Boolean.FALSE);
JComboBox = new JComboBox(model) {
  @Override public void updateUI() {
    super.updateUI();
    setUI(new javax.swing.plaf.basic.BasicComboBoxUI() {
      @Override protected JButton createArrowButton() {
        JButton button = new JButton() {
          @Override public int getWidth() {
            return 0;
          }
        };
        button.setBorder(BorderFactory.createEmptyBorder());
        button.setVisible(false);
        return button;
      }
      @Override public void configureArrowButton() {}
    });
    for(MouseListener ml:getMouseListeners()) {
      removeMouseListener(ml);
    }
  }
};
</code></pre>

### コメント
- 変換途中の日本語も、問題がないともっといいですね。 -- [toshi](http://terai.xrea.jp/toshi.html) 2006-04-24 (月) 13:45:06
    - あー、日本語のこと全然考えてなかったです…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-04-24 (月) 15:54:00
- タイトルなどを変更するとしたら`AutoCompletion`に？ -- [aterai](http://terai.xrea.jp/aterai.html) 2007-05-09 (水) 20:14:40
- 日本語を考えると`KeyReleased`より`KeyTyped`のほうがよさそうです -- [foggi](http://terai.xrea.jp/foggi.html) 2008-05-06 (火) 17:15:39
    - ご指摘ありがとうございます。`keyTyped`に変更してみました(ついでにスクリーンショットなども更新)。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-05-07 (水) 12:23:19
- <kbd>Enter</kbd>キーでの追加が出来なくなっていたのを修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-01-22 (木) 16:26:11
- 下下と入力したとき、下上と入力したときの動きがおかしいです。 -- [magi](http://terai.xrea.jp/magi.html) 2011-02-19 (Sat) 22:03:02
    - 自分の環境では再現できてません。カーソルキーを、「下、下、下、上」と入力するのでしょうか？ -- [aterai](http://terai.xrea.jp/aterai.html) 2011-02-21 (月) 15:06:15

<!-- dummy comment line for breaking list -->

