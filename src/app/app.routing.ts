import { Routes, RouterModule } from '@angular/router';

import { CompanyListComponent } from './components/companies/company-list/company-list.component';
import { CompanyComponent } from './components/companies/company/company.component';

import { OnlineTestListComponent } from './components/online-tests/online-test-list/online-test-list.component';
import { OnlineTestComponent } from './components/online-tests/online-test/online-test.component';

import { QuestionListComponent } from './components/questions/question-list/question-list.component';
import { QuestionComponent } from './components/questions/question/question.component';

import { TopicListComponent } from './components/topics/topic-list/topic-list.component';
import { TopicComponent } from './components/topics/topic/topic.component';

import { QuestionSetListComponent } from './components/question-sets/question-set-list/question-set-list.component';
import { QuestionSetComponent } from './components/question-sets/question-set/question-set.component';

import { UserListComponent } from './components/users/user-list/user-list.component';
import { UserComponent } from './components/users/user/user.component';

import { LoginComponent } from './components/login/login.component';

import { TextEditorComponent } from './components/shared/froala/texteditor.component';
import { CheckBoxComponent } from './components/shared/check-box/check-box.component';
import { RadioComponent } from './components/shared/radio/radio.component';

const appRoutes: Routes = [

  {
    path: '',
    redirectTo: '/questions',
    pathMatch: 'full'
  },
  {
    path: 'questions',
    component: QuestionListComponent
  },
  {
    path: 'question/:questionId',
    component: QuestionComponent
  },
  {
    path: 'questionSets',
    component: QuestionSetListComponent
  },
  {
    path: 'questionSet/:questionSetId',
    component: QuestionSetComponent
  },
  {
    path: 'topics',
    component: TopicListComponent
  },
  {
    path: 'topic/:topicId',
    component: TopicComponent
  },
  {
    path: 'companies',
    component: CompanyListComponent
  },
  {
    path: 'company/:companyId',
    component: CompanyComponent
  },
  {
    path: 'onlineTests',
    component: OnlineTestListComponent
  },
  {
    path: 'onlineTest/:onlineTestId',
    component: OnlineTestComponent
  },
  {
    path: 'users',
    component: UserListComponent
  },
  {
    path: 'user/:userId',
    component: UserComponent
  },
  {
    path: 'login',
    component: LoginComponent
  }
];

export const routing = RouterModule.forRoot(appRoutes);

export const routedComponents = [
  QuestionListComponent, QuestionComponent,
  QuestionSetListComponent, QuestionSetComponent,
  TopicListComponent, TopicComponent,
  CompanyListComponent, CompanyComponent,
  UserListComponent, UserComponent,
  OnlineTestComponent, OnlineTestListComponent,
  LoginComponent,
  TextEditorComponent, CheckBoxComponent, RadioComponent
];

