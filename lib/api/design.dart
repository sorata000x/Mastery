import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skillborn/services/firestore.dart';
import 'dart:ui';

const func = {
  "name": "parseSkills",
  "parameters": {
    "type": "object",
    "properties": {
      "tags": {
        "type": "array",
        "items": {
          "type": "string",
          "description": "Tag that describe the task"
        }
      },
      "skills": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "name": {
              "type": "string",
              "description":
                  "Descriptive skill name",
            },
            "description": {
              "type": "string",
              "description":
                  "General skill description. Tone: appealing and desirable."
            },
            "effect": {
              "type": "string",
              "description": "Bullet points of benefit of the skill to the user",
            },
            "cultivation": {
              "type": "string",
              "description": "Bullet points of methods to cultivate the skill",
            },
            "tags": {
              "type": "array",
              "items": {
                "type": "string",
                "description": "Tag that describe the skill"
              }
            },
            "type": {
              "type": "string",
              "description": """
                Choose one from the following list:[ 
                'energy', 'endurance', 'run-walk', 'cycling', 'swim', 'sports', 'strength', 'stretching'
                'clean', 'cook',
                'thinking', 'memory', 'focus', 'learning', 'emotion', 'creativity', 'problem-solving', 
                'mental', 
                'sleep', 'food',
                'social',
                'software', 'hardware', 
                'design',
                'other'
                ]
              """
            },
          }
        },
        "description": """
          "For the completed task, give a list of skills name, description, effect, 
          cultivation, tags, type that user gained. Skills should be broad and practical. 
          Return empty if user's task doesn't associate with any skill. 
          Example skill: { 
            “name”: "Skill Name", 
            "description": “Explain what the skill does”, 
            “effect”: “The benefits”, 
            “cultivation”: “The methods”, 
            “category”: “Other”, 
            "tags": ["tag1", "tag2", "tag3"],
            "type": "other" 
          }"
        """,
      }
    },
    "required": ["skills"]
  }
};

void main() {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference functions = db
          .collection('functions'); // User collection
  functions.doc('new-skills').set(func);
}


